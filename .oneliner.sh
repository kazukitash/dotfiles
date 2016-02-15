# このファイルを ~/.zplug/repos/b4b4r07/easy-oneliner/easy-oneliner.txt にcopy
# ワンライナーお手軽実行するためのファイル
#
# {書き方}
#     （例）
#          [これはワンライナーです] oneliner | some-command | other-command
#
#     []のなかにそのワンライナーの説明を書きます（省いても構いません）
#     []の後ろに1つ以上のスペースをあけてワンライナーを書きます
#
# {@マークについて}
#     ワンライナー中に@マークを1つだけ記述することができます
#     実行時にその@マークの位置にカーソルが置かれます
#
# {!マークについて}
#     ワンライナーの行末に!マークを置くと、ワンライナーが即座に実行されます
#
# {#マークについて}
#     2種類の使用方法があります
#     行頭に置かれた場合、その行はfzfに表示されません
#     行中に置いた場合、それ以降をコメントとみなし黒色表示します
#     ただし、後者の場合#マークの前後にスペースを必要とします
#
# {:マークについて}
#     セクションごとのタイトルに最適です
#     シェルが無視してくれる記号には#と:があります
#     #は行頭にあるとfzfが無視しますが、:は問題無いです
#

: 研究関連
[xyファイルを使って最小二乗法を計算] range="$(printf "80:199"; for i in $(seq 80 40@ 199); do; printf " $i:$(($i+39))"; done)"; for file in $(ls | grep -e "\.xy$") do least_square ${file} ${range}; done
[least_squareファイルを使って易動度を計算] a0=@2.4730; for file in $(ls | grep -e "\.xy$") do mobility ${file} ${a0}; done
[xyファイルを使って転位の移動をグラフ化] for file in $(ls | grep -e "\.xy$" | sed -e 's/\.xy//') do gnuplot -e "data='${file}'" ~/lab_src/plots/@dislocation_position.plt; done
[転位の移動をグラフ化 | 最小二乗法 | 易動度 ] a0=2.4730; range="$(printf "80:199"; for i in $(seq 80 40@ 199); do; printf " $i:$(($i+39))"; done)"; for file in $(ls | grep -e "\.xy$" | sed -e 's/\.xy//') do gnuplot -e "data='${file}'" ~/lab_src/plots/dislocation_position.plt; least_square ${file}.xy ${range}; mobility ${file} ${a0} done
[Z方向長さをまとめる] for file in $(ls | grep -e '\.mdl' | grep -v '_cna'); do; printf "%8s " $(echo $file | sed -e 's/.*deg//' -e 's/_nx.*//' -e 's/_/\./'); head -n 15 $file | awk 'NR==15 {print $3}'; done | sort@
[易動度をまとめる] for file in $(ls | grep -e '\.mobility'); do; printf "%8s " $(echo $file | sed -e 's/.*deg//' -e 's/_nx.*//' -e 's/_/\./'); echo "$(cat $file)"; done | sort@
[温度条件を変更] old_str=110000000; new_str=130000000; for mdl in $(ls | grep -e "\.mdl$"); do; echo ${mdl}; awk -v mdl="$(echo ${mdl} | sed -e 's/str$(echo ${${old_str}:0:3})/str$(echo ${${new_str}:0:3})/')" -v old_str="$(printf "/%20.15e/" $old_str | sed -e 's/\./\\./' -e 's/+/\\+/')"  -v new_str="$(printf "%20.15e" $new_str | sed -e 's/\./\\./' -e 's/+/\\+/')" 'NR == 17 {sub(old_str, new_str)}{print > mdl}' ${mdl}; rm ${mdl}; done
[xyzファイルを分割] awk 'function floor(num) {if (int(num) == num) {return num;} else if (num > 0){return int(num);} else {return int(num) - 1;}}; file = "mobility_edge_deg090_0000_nx41_ny26_nz15_edge_update_temp100_str50_for_ovito/frame_" floor(NR / 97112) ".xyz"; {print > file}' mobility_edge_deg090_0000_nx41_ny26_nz15_edge_update_temp100_str50.xyz
[動画を作成] for xyz in `ls | grep _cna.xyz | sed -e 's/\.xyz//'`; do; dir=images_`echo $xyz | sed -e 's/.*deg//' -e 's/_nx.*//'`; if [ ! -f $dir ]; then; ~/c_src/auto_see_md/see_md $xyz 1; mv images $dir; (for file in `ls ${dir} | grep eps | sed -e 's/\.eps//'`; do; convert -crop 520x534+90+83 ${dir}/${file}.eps ${dir}/${file}.png; done) &; fi; done; for dir in `ls | grep images_ | grep -v avi`; do; if [ ! -e ${dir}.avi ]; then; for file in `ls ${dir} | grep eps | sed -e 's/\.eps//'`; do; if [ ! -f ${dir}/${file}.png ]; then; echo ${dir}/${file}; convert -crop 520x534+90+83 ${dir}/${file}.eps ${dir}/${file}.png; fi; done; ffmpeg -r 20 -i ${dir}/frame_%04d.png -r 20 -an -vcodec mjpeg -q:v 0 ${dir}.avi; fi; done
[連番画像を再配列] i=0; for file in `ls | grep eps`; do; mv $file frame_`printf "%04d" i`.eps; i=$((i+1)); done

: その他
[まとめてキル] ps | grep ffmpeg | head | awk '{print "kill "$1}' | sh
