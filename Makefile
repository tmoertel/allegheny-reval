data/reval.db: data/reval_geninfo.psv data/opa_sales.psv data/ucsur_sales.psv
	rm -f data/reval.db
	bin/load_database.sh
	bin/load_sales.sh
