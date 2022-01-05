test:
	flutter test

test\:cov:
	flutter test --coverage
	genhtml coverage/lcov.info -o coverage/html

serve:
	dhttpd --path coverage/html

serve\:doc:
	dhttpd --path docs
