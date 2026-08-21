#!/bin/zsh
set -euo pipefail

PROJECT_DIR=${0:A:h:h}
BASE_VIDEO="$PROJECT_DIR/.codex-hero/media/Codex-Micro-Glass-Guide-GitHub-Cut-HeyGen-base.mp4"
HERO_IMAGE="$PROJECT_DIR/assets/codex-micro-glass-hero.png"
GUIDE_IMAGE="$PROJECT_DIR/assets/codex-micro-glass-app.png"
OUTPUT_VIDEO="$PROJECT_DIR/.codex-hero/media/Codex-Micro-Glass-Guide-GitHub-Cut-Final.mp4"

# The HeyGen master contains the approved clone voice and music. This deterministic
# pass keeps those intact, replaces generated product imagery with the real project
# assets, demonstrates the promised guide behaviors, and removes the duplicated
# closing disclosure by ending after its first complete reading.
ffmpeg -hide_banner -y \
  -i "$BASE_VIDEO" \
  -loop 1 -framerate 25 -t 180.54 -i "$HERO_IMAGE" \
  -loop 1 -framerate 25 -t 180.54 -i "$GUIDE_IMAGE" \
  -filter_complex '
    [0:v]trim=duration=180.54,setpts=PTS-STARTPTS[basev];
    [0:a]atrim=duration=180.54,asetpts=PTS-STARTPTS[outa];

    [1:v]scale=1920:1080:force_original_aspect_ratio=increase,crop=1920:1080,format=rgba,split=5[hero_open_src][hero_b][hero_c][hero_final][hero_unused];
    [hero_open_src]trim=duration=8,setpts=PTS-STARTPTS,zoompan=z=1+0.03*on/199:x=iw/2-(iw/zoom/2)+4*sin(on/28):y=ih/2-(ih/zoom/2)+2*sin(on/35):d=1:s=1920x1080:fps=25,format=rgba,fade=t=in:st=0:d=0.45:alpha=1,fade=t=out:st=7.35:d=0.65:alpha=1,setpts=PTS+0/TB[opening];
    [hero_b]trim=duration=9,setpts=PTS-STARTPTS,fade=t=in:st=0:d=0.55:alpha=1,fade=t=out:st=8.35:d=0.65:alpha=1,setpts=PTS+52/TB[paperweight];
    [hero_c]trim=duration=10,setpts=PTS-STARTPTS,fade=t=in:st=0:d=0.55:alpha=1,fade=t=out:st=9.35:d=0.65:alpha=1,setpts=PTS+74/TB[solution];
    [hero_final]trim=duration=23.54,setpts=PTS-STARTPTS,fade=t=in:st=0:d=0.45:alpha=1,setpts=PTS+157/TB[final_hero];
    [hero_unused]nullsink;

    [2:v]format=rgba,split=8[g_full_src][g_dial_src][g_agents_src][g_bottom_src][g_labels_src][g_person0_src][g_person1_src][g_person2_src];
    [g_full_src]scale=-2:900,trim=duration=7,setpts=PTS-STARTPTS,fade=t=in:st=0:d=0.45:alpha=1,fade=t=out:st=6.55:d=0.45:alpha=1,setpts=PTS+84/TB[guide_float];
    [g_dial_src]crop=610:105:20:92,scale=1500:-2,trim=duration=6.5,setpts=PTS-STARTPTS,fade=t=in:st=0:d=0.35:alpha=1,fade=t=out:st=6.15:d=0.35:alpha=1,setpts=PTS+91/TB[dial_close];
    [g_agents_src]crop=610:190:20:212,scale=1200:-2,trim=duration=6,setpts=PTS-STARTPTS,fade=t=in:st=0:d=0.35:alpha=1,fade=t=out:st=5.65:d=0.35:alpha=1,setpts=PTS+97.5/TB[agents_close];
    [g_bottom_src]crop=610:150:20:600,scale=1400:-2,trim=duration=5.7,setpts=PTS-STARTPTS,fade=t=in:st=0:d=0.35:alpha=1,fade=t=out:st=5.35:d=0.35:alpha=1,setpts=PTS+103.5/TB[bottom_close];
    [g_labels_src]scale=-2:900,trim=duration=3.1,setpts=PTS-STARTPTS,fade=t=in:st=0:d=0.3:alpha=1,fade=t=out:st=2.8:d=0.3:alpha=1,setpts=PTS+109.2/TB[guide_labels];
    [g_person0_src]scale=-2:900,trim=duration=5,setpts=PTS-STARTPTS,fade=t=in:st=0:d=0.4:alpha=1,fade=t=out:st=4.6:d=0.4:alpha=1,setpts=PTS+139/TB[person0];

    [g_person1_src]
      drawbox=x=505:y=23:w=86:h=27:color=0x0B1524@0.96:t=fill,
      drawtext=fontfile=/System/Library/Fonts/SFNS.ttf:text=MY\ LAYERS:fontcolor=0x52C8FF:fontsize=10:x=513:y=31,
      drawbox=x=27:y=225:w=186:h=77:color=0x0A72CE@0.55:t=fill,
      drawbox=x=62:y=244:w=116:h=43:color=0x07569E@0.92:t=fill,
      drawtext=fontfile=/System/Library/Fonts/SFNS.ttf:text=WRITE:fontcolor=white:fontsize=13:x=96:y=249,
      drawtext=fontfile=/System/Library/Fonts/SFNS.ttf:text=Draft\ ideas:fontcolor=white:fontsize=12:x=83:y=267,
      drawbox=x=232:y=225:w=186:h=77:color=0x18B8B8@0.55:t=fill,
      drawbox=x=267:y=244:w=116:h=43:color=0x087C83@0.92:t=fill,
      drawtext=fontfile=/System/Library/Fonts/SFNS.ttf:text=RESEARCH:fontcolor=white:fontsize=13:x=287:y=249,
      drawtext=fontfile=/System/Library/Fonts/SFNS.ttf:text=Find\ sources:fontcolor=white:fontsize=12:x=284:y=267,
      drawbox=x=437:y=225:w=186:h=77:color=0x6968E8@0.55:t=fill,
      drawbox=x=472:y=244:w=116:h=43:color=0x4946AF@0.92:t=fill,
      drawtext=fontfile=/System/Library/Fonts/SFNS.ttf:text=DESIGN:fontcolor=white:fontsize=13:x=504:y=249,
      drawtext=fontfile=/System/Library/Fonts/SFNS.ttf:text=Refine\ UI:fontcolor=white:fontsize=12:x=501:y=267,
      scale=-2:900,trim=duration=6,setpts=PTS-STARTPTS,fade=t=in:st=0:d=0.35:alpha=1,fade=t=out:st=5.65:d=0.35:alpha=1,setpts=PTS+144/TB[person1];

    [g_person2_src]
      drawbox=x=505:y=23:w=86:h=27:color=0x0B1524@0.96:t=fill,
      drawtext=fontfile=/System/Library/Fonts/SFNS.ttf:text=MY\ LAYERS:fontcolor=0x52C8FF:fontsize=10:x=513:y=31,
      drawbox=x=27:y=225:w=186:h=77:color=0x0A72CE@0.55:t=fill,
      drawbox=x=62:y=244:w=116:h=43:color=0x07569E@0.92:t=fill,
      drawtext=fontfile=/System/Library/Fonts/SFNS.ttf:text=WRITE:fontcolor=white:fontsize=13:x=96:y=249,
      drawtext=fontfile=/System/Library/Fonts/SFNS.ttf:text=Draft\ ideas:fontcolor=white:fontsize=12:x=83:y=267,
      drawbox=x=232:y=225:w=186:h=77:color=0x18B8B8@0.55:t=fill,
      drawbox=x=267:y=244:w=116:h=43:color=0x087C83@0.92:t=fill,
      drawtext=fontfile=/System/Library/Fonts/SFNS.ttf:text=RESEARCH:fontcolor=white:fontsize=13:x=287:y=249,
      drawtext=fontfile=/System/Library/Fonts/SFNS.ttf:text=Find\ sources:fontcolor=white:fontsize=12:x=284:y=267,
      drawbox=x=437:y=225:w=186:h=77:color=0x6968E8@0.55:t=fill,
      drawbox=x=472:y=244:w=116:h=43:color=0x4946AF@0.92:t=fill,
      drawtext=fontfile=/System/Library/Fonts/SFNS.ttf:text=DESIGN:fontcolor=white:fontsize=13:x=504:y=249,
      drawtext=fontfile=/System/Library/Fonts/SFNS.ttf:text=Refine\ UI:fontcolor=white:fontsize=12:x=501:y=267,
      drawbox=x=27:y=318:w=186:h=77:color=0xC83ACB@0.55:t=fill,
      drawbox=x=62:y=337:w=116:h=43:color=0x8B248D@0.92:t=fill,
      drawtext=fontfile=/System/Library/Fonts/SFNS.ttf:text=VIDEO:fontcolor=white:fontsize=13:x=99:y=342,
      drawtext=fontfile=/System/Library/Fonts/SFNS.ttf:text=Edit\ launch:fontcolor=white:fontsize=12:x=88:y=360,
      drawbox=x=232:y=318:w=186:h=77:color=0xE24A64@0.55:t=fill,
      drawbox=x=267:y=337:w=116:h=43:color=0xA72C42@0.92:t=fill,
      drawtext=fontfile=/System/Library/Fonts/SFNS.ttf:text=REVIEW:fontcolor=white:fontsize=13:x=299:y=342,
      drawtext=fontfile=/System/Library/Fonts/SFNS.ttf:text=Check\ cut:fontcolor=white:fontsize=12:x=297:y=360,
      drawbox=x=437:y=318:w=186:h=77:color=0xF19B36@0.55:t=fill,
      drawbox=x=472:y=337:w=116:h=43:color=0xA96019@0.92:t=fill,
      drawtext=fontfile=/System/Library/Fonts/SFNS.ttf:text=SHARE:fontcolor=white:fontsize=13:x=507:y=342,
      drawtext=fontfile=/System/Library/Fonts/SFNS.ttf:text=Post\ safely:fontcolor=white:fontsize=12:x=493:y=360,
      scale=-2:900,trim=duration=6.5,setpts=PTS-STARTPTS,fade=t=in:st=0:d=0.35:alpha=1,fade=t=out:st=6.15:d=0.35:alpha=1,setpts=PTS+150/TB[person2];

    [basev][opening]overlay=0:0:eof_action=pass:shortest=0[v1];
    [v1][paperweight]overlay=0:0:eof_action=pass:shortest=0[v2];
    [v2][solution]overlay=0:0:eof_action=pass:shortest=0[v3];
    [v3][final_hero]overlay=0:0:eof_action=pass:shortest=0[v4];
    [v4][guide_float]overlay=x=W-w-86+12*sin(2*PI*(t-84)/5):y=(H-h)/2+10*sin(2*PI*(t-84)/4):eof_action=pass:shortest=0[v5];
    [v5]drawbox=x=40:y=170:w=1840:h=700:color=0x050B13@1.0:t=fill:enable=between(t\,91\,109.2)[v5_clean];
    [v5_clean][dial_close]overlay=x=(W-w)/2:y=(H-h)/2:eof_action=pass:shortest=0[v6];
    [v6][agents_close]overlay=x=(W-w)/2:y=(H-h)/2:eof_action=pass:shortest=0[v7];
    [v7][bottom_close]overlay=x=(W-w)/2:y=(H-h)/2:eof_action=pass:shortest=0[v8];
    [v8][guide_labels]overlay=x=W-w-86:y=(H-h)/2:eof_action=pass:shortest=0[v9];
    [v9][person0]overlay=x=W-w-86:y=(H-h)/2:eof_action=pass:shortest=0[v10];
    [v10][person1]overlay=x=W-w-86:y=(H-h)/2:eof_action=pass:shortest=0[v11];
    [v11][person2]overlay=x=W-w-86:y=(H-h)/2:eof_action=pass:shortest=0[v12];

    [v12]
      drawtext=fontfile=/System/Library/Fonts/SFNS.ttf:text=Codex\ Micro\ Glass\ Guide:fontcolor=white:fontsize=62:x=(w-text_w)/2:y=54:box=1:boxcolor=0x08102099:boxborderw=22:enable=between(t\,0\,8),
      drawtext=fontfile=/System/Library/Fonts/SFNS.ttf:text=Codex\ Micro\ Glass\ Guide:fontcolor=white:fontsize=52:x=(w-text_w)/2:y=h-122:box=1:boxcolor=0x08102099:boxborderw=20:enable=between(t\,74\,84),
      drawbox=x=1235:y=760:w=350:h=104:color=0xFFFFFF@0.16:t=fill:enable=between(t\,86.1\,87.25),
      drawbox=x=1235:y=760:w=350:h=104:color=0xFFFFFF@0.95:t=4:enable=between(t\,86.1\,87.25),
      drawtext=fontfile=/System/Library/Fonts/SFNS.ttf:text=CLICK:fontcolor=white:fontsize=28:x=1115:y=793:box=1:boxcolor=0x087FCFAA:boxborderw=14:enable=between(t\,86.1\,87.25),
      drawbox=x=72:y=720:w=865:h=180:color=0x07111BDD@0.94:t=fill:enable=between(t\,87.25\,90.75),
      drawbox=x=72:y=720:w=865:h=180:color=0x52C8FF@0.75:t=3:enable=between(t\,87.25\,90.75),
      drawtext=fontfile=/System/Library/Fonts/SFNS.ttf:text=TOUCH\ SENSOR:fontcolor=0x7DDAFF:fontsize=34:x=112:y=756:enable=between(t\,87.25\,90.75),
      drawtext=fontfile=/System/Library/Fonts/SFNS.ttf:text=Tap\ to\ move\ to\ the\ next\ layer.:fontcolor=white:fontsize=30:x=112:y=810:enable=between(t\,87.25\,90.75),
      drawtext=fontfile=/System/Library/Fonts/SFNS.ttf:text=Hold\ for\ 3\ seconds\ to\ see\ connections.:fontcolor=0xCFEFFF:fontsize=25:x=112:y=854:enable=between(t\,87.25\,90.75),
      drawtext=fontfile=/System/Library/Fonts/SFNS.ttf:text=REAL\ GUIDE\ CLOSE-UP:fontcolor=0x7DDAFF:fontsize=25:x=90:y=85:box=1:boxcolor=0x07111BAA:boxborderw=12:enable=between(t\,91\,109.2),
      drawtext=fontfile=/System/Library/Fonts/SFNS.ttf:text=WHITE\ DIAL\ +\ JOYSTICK:fontcolor=white:fontsize=40:x=(w-text_w)/2:y=275:box=1:boxcolor=0x07111BDD:boxborderw=18:enable=between(t\,91\,97.5),
      drawtext=fontfile=/System/Library/Fonts/SFNS.ttf:text=SIX\ GLOWING\ AGENT\ KEYS:fontcolor=white:fontsize=40:x=(w-text_w)/2:y=255:box=1:boxcolor=0x07111BDD:boxborderw=18:enable=between(t\,97.5\,103.5),
      drawtext=fontfile=/System/Library/Fonts/SFNS.ttf:text=TOUCH\ SENSOR\ +\ LAYER\ LIGHTS:fontcolor=white:fontsize=40:x=(w-text_w)/2:y=260:box=1:boxcolor=0x07111BDD:boxborderw=18:enable=between(t\,103.5\,109.2),
      drawtext=fontfile=/System/Library/Fonts/SFNS.ttf:text=RENAME\ YOUR\ LAYERS:fontcolor=white:fontsize=42:x=105:y=705:box=1:boxcolor=0x07111BDD:boxborderw=17:enable=between(t\,139\,144),
      drawtext=fontfile=/System/Library/Fonts/SFNS.ttf:text=CHANGE\ THE\ LABELS:fontcolor=white:fontsize=42:x=105:y=705:box=1:boxcolor=0x07111BDD:boxborderw=17:enable=between(t\,144\,150),
      drawtext=fontfile=/System/Library/Fonts/SFNS.ttf:text=MAKE\ THE\ COLORS\ YOURS:fontcolor=white:fontsize=42:x=105:y=705:box=1:boxcolor=0x07111BDD:boxborderw=17:enable=between(t\,150\,156.5),
      drawtext=fontfile=/System/Library/Fonts/SFNS.ttf:text=Codex\ Micro\ Glass\ Guide:fontcolor=white:fontsize=64:x=(w-text_w)/2:y=56:box=1:boxcolor=0x081020B8:boxborderw=24:enable=between(t\,157\,164),
      drawtext=fontfile=/System/Library/Fonts/SFNS.ttf:text=Codex\ Micro\ Glass\ Guide:fontcolor=white:fontsize=62:x=(w-text_w)/2:y=54:box=1:boxcolor=0x081020B8:boxborderw=22:enable=between(t\,173\,180.54),
      drawtext=fontfile=/System/Library/Fonts/SFNS.ttf:text=Make\ it\ yours.\ Build\ the\ muscle\ memory.:fontcolor=white:fontsize=34:x=(w-text_w)/2:y=145:box=1:boxcolor=0x08102099:boxborderw=15:enable=between(t\,173\,180.54),
      drawtext=fontfile=/System/Library/Fonts/SFNS.ttf:text=Independent\ community\ project.\ Not\ affiliated\ with\ or\ endorsed\ by\ OpenAI\ or\ Work\ Louder.:fontcolor=white:fontsize=22:x=(w-text_w)/2:y=h-54:box=1:boxcolor=0x081020CC:boxborderw=10:enable=between(t\,173\,180.54)[outv]
  ' \
  -map '[outv]' -map '[outa]' \
  -c:v libx264 -preset medium -crf 18 -pix_fmt yuv420p \
  -c:a aac -b:a 192k -movflags +faststart -shortest -t 180.54 \
  "$OUTPUT_VIDEO"

echo "$OUTPUT_VIDEO"
