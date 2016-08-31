#!/bin/bash

docker run -dit --name py_analysis -p 8888:8888 jeffsheng/conda_labber_27_35 bash -c "jupyter notebook --notebook -dir=/opt/notebooks --ip='*' --port=8888 --no-browser"


docker run -dit --name py_scraper -p 8889:8889 jeffsheng/conda_labber_27 bash -c "source activate py27"

