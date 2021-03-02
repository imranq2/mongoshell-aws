build:
	docker image rm imranq2/mongoshell_aws:local || echo "no image"
	docker build -t imranq2/mongoshell_aws:local .

shell:
	docker run -it imranq2/mongoshell_aws:local sh