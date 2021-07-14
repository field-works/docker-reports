FROM centos:7

LABEL jp.co.field-works.vendor="Field Works, LLC." \
      jp.co.field-works.version="2.0.0"

WORKDIR /reports
COPY . .

RUN yum install -y libev

RUN cd ./fonts \
    && curl -L -o SourceHanSans-Medium.otf "https://github.com/adobe-fonts/source-han-sans/blob/release/SubsetOTF/JP/SourceHanSansJP-Medium.otf?raw=true" \
    && curl -L -o SourceHanSans-Bold.otf "https://github.com/adobe-fonts/source-han-sans/blob/release/SubsetOTF/JP/SourceHanSansJP-Bold.otf?raw=true" \
    && curl -L -o SourceHanSans-LICENSE.txt "https://github.com/adobe-fonts/source-han-sans/raw/master/LICENSE.txt" \
    && curl -L -o SourceHanSerif-Regular.otf "https://github.com/adobe-fonts/source-han-serif/blob/release/SubsetOTF/JP/SourceHanSerifJP-Regular.otf?raw=true" \
    && curl -L -o SourceHanSerif-LICENSE.txt "https://github.com/adobe-fonts/source-han-serif/raw/master/LICENSE.txt"

EXPOSE 50080
ENTRYPOINT ["./bin/reports", "server", "-l3"]
