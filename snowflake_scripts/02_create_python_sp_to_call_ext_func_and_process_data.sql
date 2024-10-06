CREATE OR REPLACE PROCEDURE NAY_DB.NAY_SCHEMA.SP_FOR_PDF_TBL_EXTRACT("TABLE_INDEX" NUMBER(38,0), "FILE_NAME" VARCHAR(16777216), "TABLE_NAME_TO_SAVE_AS" VARCHAR(16777216))
RETURNS TABLE ()
LANGUAGE PYTHON
RUNTIME_VERSION = '3.11'
PACKAGES = ('pandas==2.2.2','snowflake-snowpark-python==*')
HANDLER = 'main'
EXECUTE AS OWNER
AS '
import snowflake.snowpark as snowpark
from snowflake.snowpark.functions import col
import json
import pandas as pd

def main(session: snowpark.Session, table_index, file_name, table_name_to_save_as):
    file_name = file_name.lower()   
    pre_signed_url = session.sql(f"select get_presigned_url(@stage_for_pdf, ''{file_name}'', 200);").collect()[0][0]

    # Below I call my external function called "EXT_FUNC_FOR_PDF_TBL_EXTRACT"
    json_string = session.sql(f"select ext_func_for_pdf_tbl_extract({table_index}, ''{pre_signed_url}'');").collect()[0][0]
    json_object = json.loads(json_string)
    json_object_2 = json.loads(json_object) # this to make sure all the escpae characters are removed
    df = pd.DataFrame.from_dict(json_object_2) # still need to convert pandas df to snowpark df
    final_df = session.create_dataframe(df)
    final_df.write.save_as_table(table_name_to_save_as, mode=''overwrite'')
    return final_df
';
