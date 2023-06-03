export TZ='Asia/Kolkata' && date

git clone https://github.com/LineageOS/android_build -b lineage-18.1 --depth 1 ~/make

same() {
	echo "same"
}

notsame() {
	echo "not same"
	git clone https://github.com/LineageOS/android_build -b lineage-18.1 ~/make-update
	git -C ~/make-update rev-parse --verify --short=8 HEAD 2>/dev/null > updatedcommitid
	git add . && git commit -a -m "updatedcommitid $(date +'%Y%m%d-%H%M') [skip ci]"	
	git push origin HEAD
	cd ~/make-update
	git remote add m https://github.com/RahifM/build
	wget https://raw.githubusercontent.com/RahifM/repo_update/lineage-18.1-patches/relkey.patch && git apply relkey.patch
	git commit -a -m "relkey"
	git push -f m HEAD
	echo "Done updating :)"
}

[ "$(git -C ~/make rev-parse --verify --short=8 HEAD 2>/dev/null)" == $(cat updatedcommitid) ] && same || notsame
