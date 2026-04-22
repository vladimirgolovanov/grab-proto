.PHONY: proto clean

PROTO_SRC = proto/instagram.proto

proto:
	protoc \
		--go_out=. \
		--go_opt=module=github.com/vladimirgolovanov/grab-proto \
		--go-grpc_out=. \
		--go-grpc_opt=module=github.com/vladimirgolovanov/grab-proto \
		-I proto \
		$(PROTO_SRC)

clean:
	rm -rf gen/
