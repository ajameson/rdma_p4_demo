all:
	gcc -o rdma_p4_demo rdma_p4_demo.c pingpong.c -libverbs
