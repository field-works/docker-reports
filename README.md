# PDF テンプレートエンジン Field Reports

Field Reports（以降，本ソフトウェアと表記します）は，マルチプラットフォーム／マルチ言語に対応した PDF テンプレートエンジンです。

本 Docker イメージは，本ソフトウェアを Docker 上で使えるようにしたものです。

### 注意事項

本 Docker イメージはライセンスキーが未登録の状態で作成されているため，**試用版**として動作します。

- 試用版は，導入前の評価・動作検証以外の目的ではご利用いただけません。
- [ソフトウェア使用許諾契約](https://github.com/field-works/field-reports/blob/master/LICENSE.md)に同意の上，ご利用ください。
- 製品版への移行方法につきましては，「製品版への移行」の項をご参照ください。

試用版で出力される PDF には，以下の制約があります。

- 生成される PDF 帳票の左下にすかし文字「FIELD REPORTS (TRIAL)」が出力されます。
- PDF の文書プロパティの`Producer(PDF 変換)`が「Field Reports x.x.x (Trial)」に設定されます（`x.x.x`はバージョン番号）。

## 利用方法

### Docker コンテナの起動

```
$ docker run -it -d --name reports -p 50080:50080 fieldworks/reports
```

ログレベルを変更する場合は，追加のオプションを与えてください。

```
$ docker run -it -d --name reports -p 50080:50080 fieldworks/reports -l4
```

### Docker コンテナの停止

```
$ docker stop reports
```

## API

以下の API を提供しています。

- GET http://localhost:50080/version
- POST http://localhost:50080/render

### /version

本ソフトウェアのバージョン番号を取得します。

リクエスト：

```
GET http://localhost:50080/version
```

レスポンス：

```
HTTP/1.1 200 OK
content-length: 5

x.x.x
```

### /render

JSON 形式のレンダリングパラメータを POST すると，生成した PDF 帳票を返却します。

リクエスト：

```
POST http://localhost:50080/render
Content-Type: application/json

{
    "template": {"paper": "A4"},
    "context": {
        "hello_1": {
            "new": "Tx",
            "value": "Hello, World!",
            "rect": [100, 700, 400, 750],
            "font": "/Times-Roman"
        },
        "hello_2": {
            "new": "Tx",
            "value": "Hello, World!",
            "rect": [100, 600, 400, 650],
            "font": "/Helvetica-Oblique"
        },
        "hello_3": {
            "new": "Tx",
            "value": "Hello, World!",
            "rect": [100, 500, 400, 550],
            "font": "/Courier-Bold"
        },
        "hello_4": {
            "new": "Tx",
            "value": "ABCDEFGHIJKLMN",
            "rect": [100, 400, 400, 450],
            "font": "/ZapfDingbats"
        },
        "hello_5": {
            "new": "Tx",
            "value": "こんにちは世界",
            "rect": [100, 300, 400, 350],
            "font": "/KozGo-Medium"
        }
    }
}
```

レスポンス:

```
HTTP/1.1 200 OK
content-length: 5919
content-type: application/pdf

%PDF-1.6
%����
1 0 obj
<< /Type /Font /Subtype /Type1 /BaseFont /ZapfDingbats >>
endobj
2 0 obj
<< /Type /Font /Subtype /Type1 /BaseFont /Courier-Bold >>
endobj
3 0 obj
[ 1 [  224  266  392  551  562  883  677  213  322  322  470  677  247  343  245  370  562  562  562  562 ...

(中略)

0000005076 00000 n
0000005259 00000 n
trailer
<< /Size 22 /Info 14 0 R /ID [ (�b�7=Na��H&�k%�) (�b�7=Na��H&�k%�) ] /Root 21 0 R >>
startxref
5352
%%EOF
```

その他のリクエストサンプルについては，下記を参照してください。

- [リクエストサンプル](https://github.com/field-works/field-reports/tree/master/samples/docker)

### リソース

本 Docker イメージは，以下のディレクトリ構成となっています。

`fonts`, `images`, `templates`ディレクトリには，サンプルのフォント，画像，テンプレートが格納されています。

```
/reports
|-- bin
|   `-- reports
|-- fonts
|   |-- SourceHanSans-Bold.otf
|   |-- SourceHanSans-LICENSE.txt
|   |-- SourceHanSans-Medium.otf
|   |-- SourceHanSerif-LICENSE.txt
|   `-- SourceHanSerif-Regular.otf
|-- images
|   `-- stamp.png
`-- templates
    `-- mitumori.pdf
```

`/reports`がカレントディレクトリとなりますので，以下のような相対パスによる指定でリソースファイルを参照することができます。

```
{
    "template": "./templates/mitumori.pdf",
    "resources": {
        "font": {
            "SourceHanSerif-Regular": {
                "src": "./fonts/SourceHanSerif-Regular.otf",
                "embed": true,
                "subset": true
            }
        }
    },
    ...
}
```

必要に応じて，実際にご利用になるリソースファイルと差し替えてご利用ください。

実行例:

```
$ docker run -it -d --name reports -p 50080:50080 \
    -v /usr/share/reports/images:/reports/images \
    fieldworks/reports
```

## ユーザーズ・マニュアル

本ソフトウェアの詳細な利用方法については，ユーザーズ・マニュアルを参照してください。

- [ユーザーズ・マニュアル](https://github.com/field-works/field-reports/tree/master/doc)

## 製品版への移行

### 製品のご購入

- [販売サイト](https://www.field-works.co.jp/販売/)にてご購入ください。

### ライセンス登録

ご購入後に発行される，シリアル番号とライセンスキーを記述した初期設定ファイルを作成してください。

```:reports.conf
{
    "settings": {
        "serial-number": "<シリアル番号>",
        "auth-code": "<ライセンスキー>"
    }
}
```

作成した初期設定ファイルを，Docker コンテナの`/etc/reports.conf`にマウントさせてください。

実行例:

```
$ docker run -it -d --name reports -p 50080:50080 \
    -v /usr/share/reports/reports.conf:/etc/reports.conf \
    fieldworks/reports
```

## ソフトウェア使用許諾契約

本ソフトウェアを利用する前に，ソフトウェア使用許諾契約書をよくお読みください。

- [ソフトウェア使用許諾契約書](https://github.com/field-works/field-reports/blob/master/LICENSE.md)

本ソフトウェアでは，LGPL の適用対象となるプログラムを利用しています。
LGPL については下記を参照してください。

- [LGPL](https://www.gnu.org/licenses/lgpl-3.0.en.html)

## 製品情報

本ソフトウェアの特徴・仕様・動作環境等につきましては，下記ページをご参照ください。

- [製品情報](https://www.field-works.co.jp/製品情報/)

## サポート情報

本ソフトウェアのサポートに関する情報は，下記ページを参照してください。

- [サポート情報](https://support.field-works.co.jp/)

## お問い合わせ先

本ソフトウェアに関するお問い合せは，下記までご連絡ください。

- [お問い合わせフォーム](https://www.field-works.co.jp/お問い合わせ/)
- [E-Mail](support@field-works.co.jp)
