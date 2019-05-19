# ytcast

YouTubeから動画や音声をダウンロードして、
ローカルサーバーでiphoneにpodcast配信させる。

- 音声用のpodcastチャンネル
- 動画用のpodcastチャンネル
- podcast化しない動画・音声のディレクトリ保存  
podcast用のrssを自動生成。

## 設定

### ローカルWebサーバーを立ち上げる。

### ディレクトリを構成する
[STR_DIR]をyoutubeディレクトリで設定  
```
youtube
├── audio
├── movie
├── podcast
│   ├── audio
│   ├── movie
│   ├── thumb_audio.png
│   └── thumb_movie.png
└── tmp
```

Webサーバーの公開ディレクトリ以下にpodcastディレクトリを設定しローカル公開する。  
シンボリックリンクさせるか、
公開ディレクトリを[STR_DIR]とする。

```
Webサーバー
/var/www/html/podcast

|| イコール

[STR_DIR]/podcast
```

### podcast用のサムネイル画像を用意。
- 音声用:[STR_DIR]/podcast/thumb_audio.png
- 動画用:[STR_DIR]/podcast/thumb_movie.png

### git clone後
WORK_DIR,STR_DIR等を環境に応じて書き換える

### youtube-dlのインストール

本リポジトリの中核となるコマンド  

インストール  
（プレインストールのpython3必要）
```
sudo pip3 install youtube-dl
```

アップデート  
割と提供元からのアップデート多い
```
sudo pip3 install -U youtube-dl
```


## 使用方法

### CLIにてコマンド入力
```
./rec_youtube.sh [TYPE] [POD] [URL]
```

[TYPE]
保存したいフォーマットを指定。

- movie  :動画ファイルでダウンロード
- audio  :音声ファイルでダウンロード
- movie-list  :プレイリストを動画ファイルでダウンロード
- audio-list  :プレイリストを音声ファイルでダウンロード

[POD]
ポッドキャストにするか否か

- pod-on  
ポッドキャスト用のディレクトリにファイル移動して、
RSSを生成
- pod-off  
動画、音声用のディレクトリにファイルを移動のみ

[URL]
ダウンロードしたいyoutubeのURL

- youtube動画のURL
- youtube プレイリストのURL  
  プレイリストURLの場合、TYPEで-list形式を指定する必要がある。

### ダウンロード後
- ポッドキャスト化した場合  
[STR_DIR]/podcastにファイル保存され、それぞれRSS生成される。

- ポッドキャスト化しない場合  
[STR_DIR]内のディレクトリにそれぞれ保存

### iphone等にpodcast登録  
動画、音声と、それぞれpodcastチャンネル化される。  
以下の、URLをiphoneのpodcastに登録する
- 音声チャンネル  
http://localhost/podcast/audio.rss
- 動画チャンネル  
http://localhost/podcast/movie.rss


## 環境
raspberrypi 3b+  
OS:rasbian9.8


## makepodcast.rb
Matchy2氏作  
https://gist.github.com/matchy2/5552631

本リポジトリ用に改変  
動画、音声ファイルからPodcast用rssを生成

## メモ
### youtube-dl 主なoption

mp4動画で最高品質
```
-f 'bestvideo[ext=mp4]+bestaudio[ext=m4a]/best[ext=mp4]/best'
```

タイムスタンプをダウンロードした時刻でデフォルトにする
```
--no-mtime
```

音声だけファイル最高品質
```
youtube-dl -f bestaudio[ext=m4a]
```

URLを記述したファイルを指定してまとめてDL
```
-a, --batch-file FILE
```

ファイル名変更
```
-o '%(title)s.%(ext)s'
```

サムネイルを作成
```
--write-thumbnail
```

プレイリストごとダウンロード  
-iでダウンロードエラーを無視
```
youtube-dl -i [url]
```

### podcast使用可能フォーマット
- mp3 (audio/mpeg)
- m4a (audio/x-m4a)
- mp4 (video/mp4)
- m4v (video/x-m4v)
- mov (video/quicktime)
- pdf (application/pdf)
