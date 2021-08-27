FROM python:2 AS build

WORKDIR /opt
RUN git clone https://github.com/spiwokv/parmtSNEcv.git

##
COPY setup.py /opt/parmtSNEcv
##

RUN python -m virtualenv venv

WORKDIR /opt/parmtSNEcv
RUN bash -c "source /opt/venv/bin/activate && python -m pip install ."


#alpine
FROM python:2-slim

RUN apt-get update && apt-get install libgomp1

COPY --from=build /opt/venv /opt/venv

ENV PATH="/opt/venv/bin:$PATH"

