# ytcast

YouTubeから動画や音声をダウンロードして、
ローカルサーバーでiphoneにpodcast配信させる。

- 音声用のpodcastチャンネル
- 動画用のpodcastチャンネル
- podcast化しない動画・音声のディレクトリ保存

上記のように振り分けて、podcast用のrssを自動生成。


## 設定

### ローカルWebサーバーを立ち上げる。

### ディレクトリを構成する
任意のディレクトリを生成し[STR_DIR]に設定  
[STR_DIR]内を、以下構成で生成  
```
-podcast -movie
         -audio
-audio
-movie
```

Webサーバーの公開ディレクトリ以下にpodcastディレクトリを設定しローカル公開。  
以下のようにシンボリックリンクさせるか、
もしくは公開ディレクトリを[STR_DIR]とする。

```
Webサーバー
/var/www/html/podcast

|| イコール

[STR_DIR]/podcast
```

### podcast用のサムネイル画像を用意。
- 音声:[STR_DIR]/podcast/thumb_audio.png
- 動画:[STR_DIR]/podcast/thumb_movie.png


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
1. git clone後、  
   WORK_DIR,STR_DIR等を環境に応じて書き換える

2. localサーバーに専用ディレクトリを設定  
   /var/www/html/podcast

3. CLIにてコマンド入力
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

4. ダウンロード後
- ポッドキャスト化した場合  
STR_DIRのpodcastディレクトリにそれぞれ保存され、
それぞれRSSが生成される。

- ポッドキャスト化しない場合  
音声、動画ファイルはSTR_DIRのaudio,movie内に保存

5. iphone等にpodcast登録  
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
