FROM cirrusci/flutter:beta AS BUILDER

WORKDIR /flutter
COPY . /flutter

RUN sudo chown -R cirrus:cirrus .
RUN flutter build apk --debug
CMD ["touch", "yes"]