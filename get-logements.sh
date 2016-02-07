#!/bin/bash
check_prerequisites() {
	for command in cat curl dirname gzip jq realpath sed sleep sort tar tee xz; do
		[ -z "$(which "$command")" ] && echo "$command is required; aborting." >&2 && exit 254
	done
}
check_prerequisites

if [ "$1" == "--quiet" ]; then
	exec > /dev/null
fi

NOW="$(date +"%Y-%m-%d_%H-%M")"

PARAM_PRAGMA="Pragma: no-cache"
PARAM_ENCODING="Accept-Encoding: gzip, deflate, sdch"
PARAM_LANG="Accept-Language: fr-FR,fr;q=0.8,en-US;q=0.6,en;q=0.4,de-DE;q=0.2,de;q=0.2,nl;q=0.2,ro;q=0.2,pt;q=0.2,es;q=0.2"
PARAM_USERAGENT="User-Agent: Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Ubuntu Chromium/47.0.2526.73 Chrome/47.0.2526.73 Safari/537.36"
PARAM_ACCEPT="Accept: */*"
PARAM_CONNECTION="Connection: keep-alive"
PARAM_CACHE="Cache-Control: no-cache"

PP_PE="-H \"$PARAM_PRAGMA\" -H \"$PARAM_ENCODING\""
PP_LUA="-H \"$PARAM_LANGUAGE\" -H \"$PARAM_USERAGENT\" -H \"$PARAM_ACCEPT\""
PP_CC="-H \"$PARAM_CONNECTION\" -H \"$PARAM_CACHE\""

SLEEP=4


. "$(dirname "$0")/settings.sh" || ( echo "Settings file not found; copy settings_template.sh to settings.sh and adapt the latter to your setup." >&2 && exit 252 )
CREDENTIALSDIR="$(realpath "$CREDENTIALSDIR")"
DATADIR="$(realpath "$DATADIR")"


dodo() {

	sleep "$(($RANDOM%$SLEEP+$SLEEP))"

}


curly() {

	if [ -t 1 ]; then
		curl --compressed "$@"
	else
		curl -s -S --compressed "$@"
	fi

}


replay_session() {

	curly -X GET -b "cookies.txt" -c "cookies.txt" -H "$PARAM_PRAGMA" \
			-H "$PARAM_ENCODING" -H "Host: $PROGICILIA" \
			-H "Upgrade-Insecure-Requests: 1" \
			-H "$PARAM_LANGUAGE" -H "$PARAM_USERAGENT" -H "$PARAM_ACCEPT" \
			-H "Referer: http://$PROGICILIA/authentification/index/index" \
			-H "$PARAM_CONNECTION" -H "$PARAM_CACHE" \
			http://$PROGICILIA/accueil/accueil

	dodo

	curly -X POST -b "cookies.txt" -c "cookies.txt" -H "$PARAM_PRAGMA" \
			-H "Origin: http://$PROGICILIA" \
			-H "Accept-Encoding: gzip, deflate" -H "Host: $PROGICILIA" \
			-H "Upgrade-Insecure-Requests: 1" \
			-H "$PARAM_LANGUAGE" -H "$PARAM_USERAGENT" -H "$PARAM_ACCEPT" \
			-H "Referer: http://$PROGICILIA/authentification/index/index" \
			-H "$PARAM_CONNECTION" -H "$PARAM_CACHE" \
			-H "Content-Type: application/x-www-form-urlencoded" \
			--data-urlencode "login@$CREDENTIALSDIR/login.txt" --data-urlencode "password@$CREDENTIALSDIR/password.txt" \
			http://$PROGICILIA/authentification/index/index

	curly -X GET -b "cookies.txt" -c "cookies.txt" -H "$PARAM_PRAGMA" \
			-H "$PARAM_ENCODING" -H "Host: $PROGICILIA" \
			-H "$PARAM_LANGUAGE" -H "$PARAM_USERAGENT" -H "$PARAM_ACCEPT" \
			-H "Referer: http://$PROGICILIA/accueil/accueil" \
			-H "$PARAM_CONNECTION" -H "$PARAM_CACHE" \
			http://$PROGICILIA/library/bootstrap-3.1.1/css/bootstrap.css

	curly -X GET -b "cookies.txt" -c "cookies.txt" -H "$PARAM_PRAGMA" \
			-H "$PARAM_ENCODING" -H "Host: $PROGICILIA" \
			-H "$PARAM_LANGUAGE" -H "$PARAM_USERAGENT" -H "$PARAM_ACCEPT" \
			-H "Referer: http://$PROGICILIA/accueil/accueil" \
			-H "$PARAM_CONNECTION" -H "$PARAM_CACHE" \
			http://$PROGICILIA/library/font-awesome/css/font-awesome.css

	curly -X GET -b "cookies.txt" -c "cookies.txt" -H "$PARAM_PRAGMA" \
			-H "$PARAM_ENCODING" -H "Host: $PROGICILIA" \
			-H "$PARAM_LANGUAGE" -H "$PARAM_USERAGENT" -H "$PARAM_ACCEPT" \
			-H "Referer: http://$PROGICILIA/accueil/accueil" \
			-H "$PARAM_CONNECTION" -H "$PARAM_CACHE" \
			http://$PROGICILIA/library/nanobar.js

	curly -X GET -b "cookies.txt" -c "cookies.txt" -H "$PARAM_PRAGMA" \
			-H "$PARAM_ENCODING" -H "Host: $PROGICILIA" \
			-H "$PARAM_LANGUAGE" -H "$PARAM_USERAGENT" -H "$PARAM_ACCEPT" \
			-H "Referer: http://$PROGICILIA/accueil/accueil" \
			-H "$PARAM_CONNECTION" -H "$PARAM_CACHE" \
			http://$PROGICILIA/images/commun/icon-ma-demande.png > /dev/null

	curly -X GET -b "cookies.txt" -c "cookies.txt" -H "$PARAM_PRAGMA" \
			-H "$PARAM_ENCODING" -H "Host: $PROGICILIA" \
			-H "$PARAM_LANGUAGE" -H "$PARAM_USERAGENT" -H "$PARAM_ACCEPT" \
			-H "Referer: http://$PROGICILIA/accueil/accueil" \
			-H "$PARAM_CONNECTION" -H "$PARAM_CACHE" \
			http://$PROGICILIA/images/commun/icon-annuler-ma-demande.png > /dev/null

	curly -X GET -b "cookies.txt" -c "cookies.txt" -H "$PARAM_PRAGMA" \
			-H "$PARAM_ENCODING" -H "Host: $PROGICILIA" \
			-H "$PARAM_LANGUAGE" -H "$PARAM_USERAGENT" -H "$PARAM_ACCEPT" \
			-H "Referer: http://$PROGICILIA/accueil/accueil" \
			-H "$PARAM_CONNECTION" -H "$PARAM_CACHE" \
			http://$PROGICILIA/images/commun/icon-mes-propositions.png > /dev/null

	curly -X GET -b "cookies.txt" -c "cookies.txt" -H "$PARAM_PRAGMA" \
			-H "$PARAM_ENCODING" -H "Host: $PROGICILIA" \
			-H "$PARAM_LANGUAGE" -H "$PARAM_USERAGENT" -H "$PARAM_ACCEPT" \
			-H "Referer: http://$PROGICILIA/accueil/accueil" \
			-H "$PARAM_CONNECTION" -H "$PARAM_CACHE" \
			http://$PROGICILIA/images/commun/icon-mon-dossier.png > /dev/null

	curly -X GET -b "cookies.txt" -c "cookies.txt" -H "$PARAM_PRAGMA" \
			-H "$PARAM_ENCODING" -H "Host: $PROGICILIA" \
			-H "$PARAM_LANGUAGE" -H "$PARAM_USERAGENT" -H "$PARAM_ACCEPT" \
			-H "Referer: http://$PROGICILIA/accueil/accueil" \
			-H "$PARAM_CONNECTION" -H "$PARAM_CACHE" \
			http://$PROGICILIA/images/commun/icon-documents.png > /dev/null

	curly -X GET -b "cookies.txt" -c "cookies.txt" -H "$PARAM_PRAGMA" \
			-H "$PARAM_ENCODING" -H "Host: $PROGICILIA" \
			-H "$PARAM_LANGUAGE" -H "$PARAM_USERAGENT" -H "$PARAM_ACCEPT" \
			-H "Referer: http://$PROGICILIA/accueil/accueil" \
			-H "$PARAM_CONNECTION" -H "$PARAM_CACHE" \
			http://$PROGICILIA/images/commun/icon-consulter-les-offres.png > /dev/null

	curly -X GET -b "cookies.txt" -c "cookies.txt" -H "$PARAM_PRAGMA" \
			-H "$PARAM_ENCODING" -H "Host: $PROGICILIA" \
			-H "$PARAM_LANGUAGE" -H "$PARAM_USERAGENT" -H "$PARAM_ACCEPT" \
			-H "Referer: http://$PROGICILIA/accueil/accueil" \
			-H "$PARAM_CONNECTION" -H "$PARAM_CACHE" \
			http://$PROGICILIA/library/jquery/jquery-1.11.0.min.js

	curly -X GET -b "cookies.txt" -c "cookies.txt" -H "$PARAM_PRAGMA" \
			-H "$PARAM_ENCODING" -H "Host: $PROGICILIA" \
			-H "$PARAM_LANGUAGE" -H "$PARAM_USERAGENT" -H "$PARAM_ACCEPT" \
			-H "Referer: http://$PROGICILIA/accueil/accueil" \
			-H "$PARAM_CONNECTION" -H "$PARAM_CACHE" \
			http://$PROGICILIA/library/bootstrap-3.1.1/js/bootstrap.js

	curly -X GET -b "cookies.txt" -c "cookies.txt" -H "$PARAM_PRAGMA" \
			-H "$PARAM_ENCODING" -H "Host: $PROGICILIA" \
			-H "$PARAM_LANGUAGE" -H "$PARAM_USERAGENT" -H "$PARAM_ACCEPT" \
			-H "Referer: http://$PROGICILIA/accueil/accueil" \
			-H "$PARAM_CONNECTION" -H "$PARAM_CACHE" \
			http://$PROGICILIA/library/bootstrap-table-master/src/bootstrap-table.js

	curly -X GET -b "cookies.txt" -c "cookies.txt" -H "$PARAM_PRAGMA" \
			-H "$PARAM_ENCODING" -H "Host: $PROGICILIA" \
			-H "$PARAM_LANGUAGE" -H "$PARAM_USERAGENT" -H "$PARAM_ACCEPT" \
			-H "Referer: http://$PROGICILIA/accueil/accueil" \
			-H "$PARAM_CONNECTION" -H "$PARAM_CACHE" \
			http://$PROGICILIA/library/bootstrap-table-master/src/locale/bootstrap-table-fr-FR.js

	curly -X GET -b "cookies.txt" -c "cookies.txt" -H "$PARAM_PRAGMA" \
			-H "$PARAM_ENCODING" -H "Host: $PROGICILIA" \
			-H "$PARAM_LANGUAGE" -H "$PARAM_USERAGENT" -H "$PARAM_ACCEPT" \
			-H "Referer: http://$PROGICILIA/accueil/accueil" \
			-H "$PARAM_CONNECTION" -H "$PARAM_CACHE" \
			http://$PROGICILIA/library/bootstrap-table-master/extensions/cookie/bootstrap-table-cookie.js

	curly -X GET -b "cookies.txt" -c "cookies.txt" -H "$PARAM_PRAGMA" \
			-H "$PARAM_ENCODING" -H "Host: $PROGICILIA" \
			-H "$PARAM_LANGUAGE" -H "$PARAM_USERAGENT" -H "$PARAM_ACCEPT" \
			-H "Referer: http://$PROGICILIA/accueil/accueil" \
			-H "$PARAM_CONNECTION" -H "$PARAM_CACHE" \
			http://$PROGICILIA/library/bootstrap-datepicker/js/bootstrap-datepicker.js

	curly -X GET -b "cookies.txt" -c "cookies.txt" -H "$PARAM_PRAGMA" \
			-H "$PARAM_ENCODING" -H "Host: $PROGICILIA" \
			-H "$PARAM_LANGUAGE" -H "$PARAM_USERAGENT" -H "$PARAM_ACCEPT" \
			-H "Referer: http://$PROGICILIA/accueil/accueil" \
			-H "$PARAM_CONNECTION" -H "$PARAM_CACHE" \
			http://$PROGICILIA/library/bootstrap-datepicker/js/locales/bootstrap-datepicker.fr.js

	curly -X GET -b "cookies.txt" -c "cookies.txt" -H "$PARAM_PRAGMA" \
			-H "$PARAM_ENCODING" -H "Host: $PROGICILIA" \
			-H "$PARAM_LANGUAGE" -H "$PARAM_USERAGENT" -H "$PARAM_ACCEPT" \
			-H "Referer: http://$PROGICILIA/accueil/accueil" \
			-H "$PARAM_CONNECTION" -H "$PARAM_CACHE" \
			http://$PROGICILIA/js/edemande.js

	curly -X GET -b "cookies.txt" -c "cookies.txt" -H "$PARAM_PRAGMA" \
			-H "$PARAM_ENCODING" -H "Host: $PROGICILIA" \
			-H "$PARAM_LANGUAGE" -H "$PARAM_USERAGENT" -H "$PARAM_ACCEPT" \
			-H "Referer: http://$PROGICILIA/accueil/accueil" \
			-H "$PARAM_CONNECTION" -H "$PARAM_CACHE" \
			http://$PROGICILIA/js/commun/commun.js

	curly -X GET -b "cookies.txt" -c "cookies.txt" -H "$PARAM_PRAGMA" \
			-H "$PARAM_ENCODING" -H "Host: $PROGICILIA" \
			-H "$PARAM_LANGUAGE" -H "$PARAM_USERAGENT" -H "$PARAM_ACCEPT" \
			-H "Referer: http://$PROGICILIA/accueil/accueil" \
			-H "$PARAM_CONNECTION" -H "$PARAM_CACHE" \
			http://$PROGICILIA/library/sweetalert/lib/sweet-alert.js

	curly -X GET -b "cookies.txt" -c "cookies.txt" -H "$PARAM_PRAGMA" \
			-H "$PARAM_ENCODING" -H "Host: $PROGICILIA" \
			-H "$PARAM_LANGUAGE" -H "$PARAM_USERAGENT" -H "$PARAM_ACCEPT" \
			-H "Referer: http://$PROGICILIA/accueil/accueil" \
			-H "$PARAM_CONNECTION" -H "$PARAM_CACHE" \
			http://$PROGICILIA/library/bootstrap-filestyle.min.js

	curly -X GET -b "cookies.txt" -c "cookies.txt" -H "$PARAM_PRAGMA" \
			-H "$PARAM_ENCODING" -H "Host: $PROGICILIA" \
			-H "$PARAM_LANGUAGE" -H "$PARAM_USERAGENT" -H "$PARAM_ACCEPT" \
			-H "Referer: http://$PROGICILIA/accueil/accueil" \
			-H "$PARAM_CONNECTION" -H "$PARAM_CACHE" \
			http://$PROGICILIA/js/accueil.js

	curly -X GET -b "cookies.txt" -c "cookies.txt" -H "$PARAM_PRAGMA" \
			-H "$PARAM_ENCODING" -H "Host: $PROGICILIA" \
			-H "$PARAM_LANGUAGE" -H "$PARAM_USERAGENT" -H "$PARAM_ACCEPT" \
			-H "Referer: http://$PROGICILIA/library/bootstrap-3.1.1/css/bootstrap.css" \
			-H "$PARAM_CONNECTION" -H "$PARAM_CACHE" \
			http://$PROGICILIA/images/commun/bandeau.png > /dev/null

	dodo

	curly -X GET -b "cookies.txt" -c "cookies.txt" -H "$PARAM_PRAGMA" \
			-H "Origin: http://$PROGICILIA" \
			-H "$PARAM_ENCODING" -H "Host: $PROGICILIA" \
			-H "$PARAM_LANGUAGE" -H "$PARAM_USERAGENT" -H "$PARAM_ACCEPT" \
			-H "Referer: http://$PROGICILIA/library/font-awesome/css/font-awesome.css" \
			-H "$PARAM_CONNECTION" -H "$PARAM_CACHE" \
			http://$PROGICILIA/accueil/accueil

	curly -X GET -b "cookies.txt" -c "cookies.txt" -H "$PARAM_PRAGMA" \
			-H "$PARAM_ENCODING" -H "Host: $PROGICILIA" \
			-H "$PARAM_LANGUAGE" -H "$PARAM_USERAGENT" -H "$PARAM_ACCEPT" \
			-H "Referer: http://$PROGICILIA/accueil/accueil" \
			-H "$PARAM_CONNECTION" -H "$PARAM_CACHE" \
			http://$PROGICILIA/library/jquery/jquery-1.11.0.min.js

	curly -X GET -b "cookies.txt" -c "cookies.txt" -H "$PARAM_PRAGMA" \
			-H "Origin: http://$PROGICILIA" \
			-H "$PARAM_ENCODING" -H "Host: $PROGICILIA" \
			-H "$PARAM_LANGUAGE" -H "$PARAM_USERAGENT" -H "$PARAM_ACCEPT" \
			-H "Referer: http://$PROGICILIA/library/font-awesome/css/font-awesome.css" \
			-H "$PARAM_CONNECTION" -H "$PARAM_CACHE" \
			http://$PROGICILIA/library/font-awesome/fonts/fontawesome-webfont.woff2?v=4.3.0 > /dev/null

	curly -X GET -b "cookies.txt" -c "cookies.txt" -H "$PARAM_PRAGMA" \
			-H "$PARAM_ENCODING" -H "Host: $PROGICILIA" \
			-H "$PARAM_LANGUAGE" -H "$PARAM_USERAGENT" -H "$PARAM_ACCEPT" \
			-H "Referer: http://$PROGICILIA/accueil/accueil" \
			-H "$PARAM_CONNECTION" -H "$PARAM_CACHE" \
			http://$PROGICILIA/library/sweetalert/lib/sweet-alert.js

	curly -X GET -b "cookies.txt" -c "cookies.txt" -H "$PARAM_PRAGMA" \
			-H "Origin: http://$PROGICILIA" \
			-H "$PARAM_ENCODING" -H "Host: $PROGICILIA" \
			-H "$PARAM_LANGUAGE" -H "$PARAM_USERAGENT" -H "$PARAM_ACCEPT" \
			-H "Referer: http://$PROGICILIA/library/font-awesome/css/font-awesome.css" \
			-H "$PARAM_CONNECTION" -H "$PARAM_CACHE" \
			http://$PROGICILIA/library/font-awesome/fonts/fontawesome-webfont.woff?v=4.3.0 > /dev/null

	dodo

	curly -X GET -b "cookies.txt" -c "cookies.txt" -H "$PARAM_PRAGMA" \
			-H "$PARAM_ENCODING" -H "Host: $PROGICILIA" \
			-H "Upgrade-Insecure-Requests: 1" \
			-H "$PARAM_LANGUAGE" -H "$PARAM_USERAGENT" -H "$PARAM_ACCEPT" \
			-H "Referer: http://$PROGICILIA/accueil/accueil" \
			-H "$PARAM_CONNECTION" -H "$PARAM_CACHE" \
			http://$PROGICILIA/offrelogement/index/

	curly -X GET -b "cookies.txt" -c "cookies.txt" -H "$PARAM_PRAGMA" \
			-H "Origin: http://$PROGICILIA" \
			-H "$PARAM_ENCODING" -H "Host: $PROGICILIA" \
			-H "$PARAM_LANGUAGE" -H "$PARAM_USERAGENT" -H "$PARAM_ACCEPT" \
			-H "Referer: http://$PROGICILIA/library/font-awesome/css/font-awesome.css" \
			-H "$PARAM_CONNECTION" -H "$PARAM_CACHE" \
			http://$PROGICILIA/accueil/accueil

	curly -X GET -b "cookies.txt" -c "cookies.txt" -H "$PARAM_PRAGMA" \
			-H "Origin: http://$PROGICILIA" \
			-H "$PARAM_ENCODING" -H "Host: $PROGICILIA" \
			-H "$PARAM_LANGUAGE" -H "$PARAM_USERAGENT" -H "$PARAM_ACCEPT" \
			-H "Referer: http://$PROGICILIA/library/font-awesome/css/font-awesome.css" \
			-H "$PARAM_CONNECTION" -H "$PARAM_CACHE" \
			http://$PROGICILIA/library/font-awesome/fonts/fontawesome-webfont.woff2?v=4.3.0 > /dev/null

	curly -X GET -b "cookies.txt" -c "cookies.txt" -H "$PARAM_PRAGMA" \
			-H "Origin: http://$PROGICILIA" \
			-H "$PARAM_ENCODING" -H "Host: $PROGICILIA" \
			-H "$PARAM_LANGUAGE" -H "$PARAM_USERAGENT" -H "$PARAM_ACCEPT" \
			-H "Referer: http://$PROGICILIA/library/font-awesome/css/font-awesome.css" \
			-H "$PARAM_CONNECTION" -H "$PARAM_CACHE" \
			http://$PROGICILIA/library/font-awesome/fonts/fontawesome-webfont.woff?v=4.3.0 > /dev/null

	dodo

	curly -X GET -b "cookies.txt" -c "cookies.txt" -H "$PARAM_PRAGMA" \
			-H "$PARAM_ENCODING" -H "Host: $PROGICILIA" \
			-H "Upgrade-Insecure-Requests: 1" \
			-H "$PARAM_LANGUAGE" -H "$PARAM_USERAGENT" -H "$PARAM_ACCEPT" \
			-H "Referer: http://$PROGICILIA/offrelogement/index/deleteCache/delete" \
			-H "$PARAM_CONNECTION" -H "$PARAM_CACHE" \
			http://$PROGICILIA/offrelogement/index/deleteCache/delete

	dodo

	curly -X GET -b "cookies.txt" -c "cookies.txt" -H "$PARAM_PRAGMA" \
			-H "Origin: http://$PROGICILIA" \
			-H "$PARAM_ENCODING" -H "Host: $PROGICILIA" \
			-H "$PARAM_LANGUAGE" -H "$PARAM_USERAGENT" -H "$PARAM_ACCEPT" \
			-H "Referer: http://$PROGICILIA/library/font-awesome/css/font-awesome.css" \
			-H "$PARAM_CONNECTION" -H "$PARAM_CACHE" \
			http://$PROGICILIA/accueil/accueil

}


show_data() {

	replay_session | tee "session.txt" | sort -u | sed -ne 's,.* data-url="\([^"]*\)".*,\1,p' | while read datafile; do
		curly -X GET -b "cookies.txt" -c "cookies.txt" -H "$PARAM_PRAGMA" \
				-H "$PARAM_ENCODING" -H "Host: $PROGICILIA" \
				-H "$PARAM_LANGUAGE" -H "$PARAM_USERAGENT" -H "$PARAM_ACCEPT" \
				-H "Referer: http://$PROGICILIA/offrelogement/index" \
				-H "Content-Type: application/json" -H "X-Requested-With: XMLHttpRequest" \
				-H "$PARAM_CONNECTION" -H "$PARAM_CACHE" \
				"http://$PROGICILIA$datafile?sort=log_loyer_charge_comprise&order=asc&limit=25&offset=0" \
				| tee "latest.json" | jq .
	done | tee "data_${NOW}.json" && xz -9 -M "$MEMLIMIT" "session.txt"

}


make_history() {

	retar=0
	if [ -f "archive.tar.xz" ]; then
		tar -Jxf "archive.tar.xz" && retar=1
	else
		retar=1
	fi
	(
		echo '{'
		ls "data_"*".json" | sort -r | while read f; do
			date="$(echo "$f" | sed -e 's,.*/data_\(.*\)\.json$,\1,' -e 's,^\([0-9][0-9][0-9][0-9]-[0-9][0-9]-[0-9][0-9]\)_\([0-9][0-9]\)-\([0-9][0-9]\)$,\1 \2:\3,')"
			size="$(ls -al "$f" | cut -f5 -d' ')"
			[ "$first" == "no" ] && echo ','
			first="no"
			echo -n "\"$date\": "
			if [ "$size" -ne 0 ]; then
				cat "$f"
			else
				echo "\"no data in $f\""
			fi
		done
		echo '}'
	) | gzip -9 > "history.json.gz"
	[ "$retar" == 1 ] && tar -c "data_"*".json" | xz -9 -M "$MEMLIMIT" > "archive.tar.xz" && rm "data_"*".json"

}


mkdir -p "$DATADIR" || ( echo "Failed to create $DATADIR; aborting;" >&2 && exit 253 )
pushd "$DATADIR" > /dev/null

show_data

make_history

popd > /dev/null

