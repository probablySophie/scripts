FROM python:latest

# Install Django!
RUN python -m pip install Django

# Pillow does image viewing
RUN python -m pip install Pillow

# Import Django
# RUN python -m import django
