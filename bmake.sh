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
	curl https://github.com/RahifM/build/commit/6af3716772b9e10a682cc9957f4e632c6e8d2ab6.patch | git am -3
	curl https://github.com/RahifM/build/commit/b8d6293c1a822898d787f4e5aec741be1e58e4ae.patch | git am -3
	git push -f m HEAD
	echo "Done updating :)"
}

[ "$(git -C ~/make rev-parse --verify --short=8 HEAD 2>/dev/null)" == $(cat updatedcommitid) ] && same || notsame
