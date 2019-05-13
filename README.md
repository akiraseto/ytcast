# ytcast

youtubeから動画や音声をダウンロードして、
localでiphoneにpodcast配信させる。

音声用のpodcastチャンネル  
動画用のpodcastチャンネル  
podcast化しない動画、音声のディレクトリ保存と  
用途別に応じて振り分けて、podcast用のrssを自動生成させる。

## 環境
raspberrypi 3b+  
OS:rasbian9.8

## youtube-dl

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

### 主に使うオプションを以下に記す

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

## makepodcast.rb
Matchy2氏作  
https://gist.github.com/matchy2/5552631

本リポジトリ用に改変  
動画、音声ファイルからPodcast用rssを生成

## メモ
### podcast使用可能フォーマット
- mp3 (audio/mpeg)
- m4a (audio/x-m4a)
- mp4 (video/mp4)
- m4v (video/x-m4v)
- mov (video/quicktime)
- pdf (application/pdf)
