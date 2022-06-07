# Build Instructions

Make sure that you have libibverbs and associated development packages installed, then compile with:

    ./compile.sh

# Running Instructions

On the server/remote end, run 

    rdma_p4_demo -d <IBDEV>

On the client/local end runt

    rdma_p4_demo -d <IBDEV> <SERVER_IP_ADDR>

Note that the SERVER_IP_ADDR is not used for any of the remote communications, but the IBDEV must be a valid local device that supports IB Verbs (e.g. a Mellanox NIC).

## Server side

When running the demo with a server, the application will launch, print the local LID, QPN, PSN and GID to stdout, then wait for input from STDIN. The user should copy the colon delimited string that contains these parameters. An example of this is shown below

    jam192@mace3:~/rdma_p4_demo$ ./build/rdma_p4_demo -d mlx5_1 -g 3
      local address:  LID 0x0000, QPN 0x0011db, PSN 0xb3493a, GID ::ffff:192.168.0.25
    0000:0011db:b3493a:00000000000000000000ffffc0a80019
    Enter remote LID:QPN:PSN:GID

Once you have copied this string (second last line, which is 0000:0011db:b3493a:00000000000000000000ffffc0a80019), press Enter, and the server application will being printing the contents of the RDMA receive buffer once per second, as per the below. Note that the receive buffer is initialized to value 123.

    buf[0-64] 123 123 123 123 123 123 123 123 123 123 123 123 123 123 123 123 123 123 123 123 123 123 123 123 123 123 123 123 123 123 123 123 123 123 123 123 123 123 123 123 123 123 123 123 123 123 123 123 123 123 123 123 123 123 123 123 123 123 123 123 123 123 123 123
    buf[0-64] 123 123 123 123 123 123 123 123 123 123 123 123 123 123 123 123 123 123 123 123 123 123 123 123 123 123 123 123 123 123 123 123 123 123 123 123 123 123 123 123 123 123 123 123 123 123 123 123 123 123 123 123 123 123 123 123 123 123 123 123 123 123 123 123
    buf[0-64] 123 123 123 123 123 123 123 123 123 123 123 123 123 123 123 123 123 123 123 123 123 123 123 123 123 123 123 123 123 123 123 123 123 123 123 123 123 123 123 123 123 123 123 123 123 123 123 123 123 123 123 123 123 123 123 123 123 123 123 123 123 123 123 123

## Client side

When running the client side of the demo, run the same application, but provide an additional command line argument to configure it as a client. This will also print the local LID, QPN, PSN and GID, and then will wait for you to supply these parameters from the server. Copy and past the string from the server side and presss enter

    ajameson@pst-beam1:~/rdma_p4_demo/build$ ./rdma_p4_demo -d mlx5_3 -g 0 mace3
      local address:  LID 0x0000, QPN 0x0011f3, PSN 0x9e0034, GID fe80::526b:4bff:fe4b:308b
    0000:0011f3:9e0034:fe80000000000000526b4bfffe4b308b
    Enter remote LID:QPN:PSN:GID ^[[A

Once you have pasted the connection info and pressed enter, then client side will send via RDMA the local buffer which will then appear in the output buffer in the server, causing that application to return, demonstrating the RDMA operation. The client will write the following values (just the first 64 values shown) to the buffer that is sent

    sending buf[0-64] 0 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25 26 27 28 29 30 31 32 33 34 35 36 37 38 39 40 41 42 43 44 45 46 47 48 49 50 51 52 53 54 55 56 57 58 59 60 61 62 63
    4096 bytes in 0.00 seconds = 6553.60 Mbit/sec
    1 iters in 0.00 seconds = 5.00 usec/iter

## Server Receiving Reply

Once the RDMA message has been received on the server, it should show that the contents of the receive buffer has changed - only values from index 40 onwards are changed. When this happens, the final few lines printed by the server are shown below

    buf[0-64] 123 123 123 123 123 123 123 123 123 123 123 123 123 123 123 123 123 123 123 123 123 123 123 123 123 123 123 123 123 123 123 123 123 123 123 123 123 123 123 123 40 41 42 43 44 45 46 47 48 49 50 51 52 53 54 55 56 57 58 59 60 61 62 63
    4096 bytes in 7.00 seconds = 0.00 Mbit/sec
    1 iters in 7.00 seconds = 7001528.00 usec/iter

# RDMA integration with the P4

It should be possible for the P4 switch to use the LID, QPN and PSN to send a packet similar to the client side, demonstrating that RDMA from the P4 to a server is possible.
