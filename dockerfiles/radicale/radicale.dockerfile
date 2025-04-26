FROM python:latest

RUN python -m pip install --user --upgrade https://github.com/Kozea/Radicale/archive/master.tar.gz

CMD ["/user/bin/env", "python3", "-m radicale"]
