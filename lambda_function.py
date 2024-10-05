import json
# import boto3
import requests
import camelot
import io
import cv2
import logging

logger = logging.getLogger()
logger.setLevel(logging.INFO)


def lambda_handler(event, context):

    event_body = event["body"]
    payload = json.loads(event_body)

    input_data = payload["data"]

    if len(input_data) < 2:
        (object_key := input_data[0][-1])
        (df_index := input_data[0][-2])
    else:
        (object_key := input_data[1])
        (df_index := input_data[0]) 

    logger.info(f"Input Data (expected an array/list): {input_data}")

    logger.info(f"Pre-signed URL:  {object_key}")
    logger.info(f"Table index: {df_index}")

    response = requests.get(object_key)
    pdf_content = response.content
    
    # 200 is the HTTP status code for "ok".
    status_code = 200

    try:

        # Read the PDF using camelot
        tables = camelot.read_pdf(io.BytesIO(pdf_content), pages='all')
        df0 = tables[df_index].df

        # if using camelot package, the output df tends to have the header row as a separate row so we need to fix it
        header = df0.iloc[0]
        df1 = df0[1:]
        df1.columns = header

        # finally, will attempt to pass the contents of the output df/table to SF in json format
        # df_json = df1.to_json()
        if all(header.tolist()):
            (df_json := df1.to_json())
        else:
            # Convert header to a list and rename column names with empty string
            header_list = header.tolist()
            counter = 1
            col_on_hold = None
            for i, col in enumerate(header_list):
                if i > 0 and col == '':
                    # header_list[i] = header_list[i - 1] + '_' + str(counter)
                    header_list[i] = col_on_hold + '_' + str(counter)
                    counter += 1
                elif i == 0 and col == '':
                    header_list[i] = 'holder_for_empty_col_name'
                    col_on_hold = header_list[i]
                else:
                    col_on_hold = col
                    counter = 1

            df1.columns = header_list
            (df_json := df1.to_json())

        # convert this df_json to str to see if that could work
        output_lst = [[0, str(df_json)]]

        output = json.dumps({"data": output_lst})

        logger.info(f"Unprocessed json: {df_json}")
        logger.info(f"Processed json output to return: {output}")

    except Exception as err:
        # 400 implies some type of error.
        status_code = 400
        # Tell caller what this function could not handle.
        logger.info(f"Exception: {str(err)}")
        output = json.dumps({"data": str(err)})

    # Return the return value and HTTP status code.
    return {
        'statusCode': status_code,
        'body': output
    }
