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
TITLE_AUDIO="YOUTUBEの音声"
TITLE_MOVIE="YOUTUBEの動画"
DOC_ROUTE="/var/www/html/podcast"
URL_AUDIO="podcast/audio"
URL_MOVIE="podcast/movie"

#オプション指定
#共通
COMMON="--no-mtime -o %(title)s.%(ext)s "

#音声のみ
AUDIO="-f bestaudio[ext=m4a]"

#動画の場合
MOVIE="-f bestvideo[ext=mp4]+bestaudio[ext=m4a]/best[ext=mp4]/best"
#todo:上限決める？キレイすぎて容量重いのがある

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
elif [ $TYPE = movie-list ]; then
    #再生リストの場合（動画）
    OPT="${COMMON} ${MOVIE} ${LIST}"
else
    echo "Error type"
fi

#ディレクトリ移動
cd $STR_DIR/tmp

#youtubeをDL
youtube-dl $OPT $URL

#リネーム
#todo: 必要ないかも。保留

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

