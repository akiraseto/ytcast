#!/usr/bin/env bash

#動画、音声、音声リスト、動画リスト:movie, audio, audio-list, movie-list
TYPE=$1

#podcast化するかどうか: pod-on, pod-off
POD=$2

#URL
URL=$3

#使用するディレクトリ
STR_DIR="${HOME}/rasUSB/youtube"
WORK_DIR="${HOME}/youtube"

#PODCAST化
HOST_IP=`hostname -I | cut -f1 -d' '` # eth0
TITLE_AUDIO="YOUTUBE音声"
TITLE_MOVIE="YOUTUBE動画"
DOC_ROUTE="/var/www/html/podcast"
URL_AUDIO="podcast/audio"
URL_MOVIE="podcast/movie"

#オプション指定
#共通
COMMON="--no-mtime -o %(title)s.%(ext)s "

#音声のみ
AUDIO="-f bestaudio[ext=m4a]"

#動画の場合
#最高品質
#MOVIE="-f bestvideo[ext=mp4]+bestaudio[ext=m4a]/best[ext=mp4]/best"
#iphone7(1334*750)での最良品質
MOVIE="-f bestvideo[ext=mp4][height=750]+bestaudio[ext=m4a]/best[ext=mp4]/best"

#再生リストの場合
LIST="-i"

if [ $TYPE = audio ]; then
    #音声のみの場合
    OPT="${COMMON} ${AUDIO}"
elif [ $TYPE = movie ]; then
    #動画の場合
    OPT="${COMMON} ${MOVIE}"
elif [ $TYPE = audio-list ]; then
    #再生リストの場合（音声）
    OPT="${COMMON} ${AUDIO} ${LIST}"
    URL=${URL//v=*\&/}
elif [ $TYPE = movie-list ]; then
    #再生リストの場合（動画）
    OPT="${COMMON} ${MOVIE} ${LIST}"
    URL=${URL//v=*\&/}
else
    echo "Error type"
fi

#ディレクトリ移動
cd $STR_DIR/tmp

#youtubeをDL
youtube-dl $OPT $URL

#タイトル名の&,スペースを削除
rename 's/(\&|　| )/_/g' ./*.mp4
rename 's/(\&|　| )/_/g' ./*.m4a

#ファイル移動と、podcast化
if [ $POD = "pod-on" ]; then
#podcast化
    if [ `echo $TYPE | grep 'audio'` ]; then
        #audio系の場合
        mv ./*.m4a $STR_DIR/podcast/audio

        #rss生成
        ruby $WORK_DIR/makepodcast.rb $TITLE_AUDIO http://$HOST_IP/$URL_AUDIO/ $DOC_ROUTE/audio > $DOC_ROUTE/audio.rss

    elif [ `echo $TYPE | grep 'movie'` ]; then
        #movie系の場合
        mv ./*.mp4 $STR_DIR/podcast/movie

        #rss生成
        ruby $WORK_DIR/makepodcast.rb $TITLE_MOVIE http://$HOST_IP/$URL_MOVIE/ $DOC_ROUTE/movie > $DOC_ROUTE/movie.rss
    fi

elif [ $POD = pod-off ]; then
#podcastしない
    if [ `echo $TYPE | grep 'audio'` ]; then
        mv ./*.m4a $STR_DIR/audio
    elif [ `echo $TYPE | grep 'movie'` ]; then
        mv ./*.mp4 $STR_DIR/movie
    fi
else
    echo "エラー"
fi
