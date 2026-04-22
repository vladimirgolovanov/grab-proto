# grab-proto

gRPC/protobuf definitions for Instagram data retrieval. Provides two streaming RPCs:

- **CheckUsername** — checks whether Instagram usernames exist
- **GetPost** — fetches post metadata (text, image URL) by post URLs

---

## Installation

```bash
go get github.com/vladimirgolovanov/grab-proto
```

---

## Usage as a gRPC Client

```go
package main

import (
	"context"
	"fmt"
	"log"

	instagram "github.com/vladimirgolovanov/grab-proto/gen/instagram"
	"google.golang.org/grpc"
	"google.golang.org/grpc/credentials/insecure"
)

func main() {
	conn, err := grpc.NewClient("localhost:50051", grpc.WithTransportCredentials(insecure.NewCredentials()))
	if err != nil {
		log.Fatal(err)
	}
	defer conn.Close()

	client := instagram.NewInstagramClient(conn)

	// Check usernames
	stream, err := client.CheckUsername(context.Background(), &instagram.CheckUsernameRequest{
		Usernames: []string{"user1", "user2"},
	})
	if err != nil {
		log.Fatal(err)
	}
	for {
		resp, err := stream.Recv()
		if err != nil {
			break
		}
		fmt.Printf("%s: exists=%v\n", resp.Username, resp.Exists)
	}

	// Get post metadata
	postStream, err := client.GetPost(context.Background(), &instagram.GetPostRequest{
		PostUrls: []string{"https://www.instagram.com/p/example/"},
	})
	if err != nil {
		log.Fatal(err)
	}
	for {
		resp, err := postStream.Recv()
		if err != nil {
			break
		}
		fmt.Printf("url=%s text=%s image=%s\n", resp.PostUrl, resp.Text, resp.ImageUrl)
	}
}
```

---

## Proto source

The service is defined in [`proto/instagram.proto`](proto/instagram.proto). To regenerate Go code:

```bash
make proto
```

Requires `protoc`, `protoc-gen-go`, and `protoc-gen-go-grpc` installed.
