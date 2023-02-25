FROM python:3.9-slim

WORKDIR /usr/src/app
COPY ./ ./

RUN python3 -m pip install -r requirements.txt

# Create dataset with the latest data for 2022-23 season
RUN python3 -m src.Process-Data.Get_Data
RUN python3 -m src.Process-Data.Create_Games

# Train models
RUN python3 -m src.Train-Models.XGBoost_Model_ML
RUN python3 -m src.Train-Models.XGBoost_Model_UO

ENV SPORT="NBA"
ENV ODDS="fanduel"
ENV DATE=""

# The next line is needed for running Ubuntu under WSL2 on Windows
# RUN rm -rf /usr/lib/x86_64-linux-gnu/libnvidia-ml.so.1 /usr/lib/x86_64-linux-gnu/libcuda.so.1

CMD python3 main.py -A -odds=$ODDS -sport=$SPORT -date=$DATE
