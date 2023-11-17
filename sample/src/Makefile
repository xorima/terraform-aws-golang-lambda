build:
	GOOS=linux GOARCH=arm64 go build -tags lambda.norpc -o bootstrap main.go
	zip ../sample.zip bootstrap
	@rm bootstrap
