import os
import logging

# import dagster
from dagster import op
from dagster import job
from dagster import sensor
from dagster import RunRequest
from dagster import repository


@op(config_schema={'filename': str})
def process_file(context):
    filename = context.op_config['filename']
    context.log.info(filename)


@job
def log_file_job():
    process_file()


MY_DIRECTORY = '.'


@sensor(job=log_file_job)
def my_directory_sensor(context):
    logger = logging

    for filename in os.listdir(MY_DIRECTORY):
        filepath = os.path.join(MY_DIRECTORY, filename)
        if os.path.isfile(filepath):

            logger.info(f'trigger job "{filename}".')
            yield RunRequest(run_key=filename,
                             run_config={
                                 'ops': {
                                     'process_file': {
                                         'config': {
                                             'filename': filename
                                         }
                                     }
                                 }
                             })


@repository
def sensor_demo_repo():
    return [log_file_job, my_directory_sensor]
