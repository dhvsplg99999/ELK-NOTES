
# Elasticsearch 

Elasticsearch như là trái tim của ELK Stack. Elasticsearch dựa trên nền tảng của Lucene Apache. Elasticsearch là phân mềm dùng với chức năng tương tự như database trong ELK Stack, ngoài chức năng lưu trữ dữ liệu phân tán  Elasticsearch còn có thê truy vấn và phân tích dữ liệu được hỗ trợ bởi giao thức REST APIs. 

Elasticsearch APIs hỗ trợ các cấu trúc query dùng để truy vấn dữ liệu(structured queries, full text queries, and complex queries that combine the two) ( giả sử như bạn muốn sắp xếp số tuổi của các ứng viên phỏng vấn từ thấp đến cao ). 

Elasticsearch cho phép bạn có thể xây dựng, phân tách  các tập hợp dữ liệu của bạn để giúp bạn có thể phục vụ mục đích tìm kiếm data một cách nhanh nhất .
 Trước khi đi tìm hiểu Elasticsearch là việc ra sao chúng ta đi qua một vài khái niệm cơ bản liên quan đến Elasticsearch :

 ###1. Document 
  là một JSON Object chứa dữ liệu bên trong, là basic infomation unit của ELK Stack ( hiểu cơ bản thì đây là đơn vị nhỏ nhất lưu trữ dữ liệu trong Elasticsearch) 


### 2. Index

Elasticsearch sử dụng cấu trúc tìm kiếm gọi là ` inverted index `, được thiết kể để tìm kiếm full text search. Nó hoạt động như sau : 
```
 Văn bản nhận được sẽ được phân tách thành các từ rồi các từ đó sẽ được so sánh với data cần tìm và đưa ra kết quả .
 ```
 Để cụ thể chúng ta sẽ tham khảo ví dụ để hiểu rõ hơn :
 Chúng ta có 2 văn bản 
 ```
1,The quick brown fox jumped over the lazy dog
2,Quick brown foxes leap over lazy dogs in summer
```
Tạo ra một inverted index, chúng ta tác biệt từng từ của đoạn văn bản và sắp xếp chúng lại và đánh dấu các terms thuộc nhóm văn bản nào .

```
Term      Doc_1  Doc_2
-------------------------
Quick   |       |  X
The     |   X   |
brown   |   X   |  X
dog     |   X   |
dogs    |       |  X
fox     |   X   |
foxes   |       |  X
in      |       |  X
jumped  |   X   |
lazy    |   X   |  X
leap    |       |  X
over    |   X   |  X
quick   |   X   |
summer  |       |  X
the     |   X   |
------------------------
```

Giả sử chúng ta muốn tìm cụm từ ` quick brown ` chúng ta chỉ cần so sánh xem nó match với doc nào nhiều hơn sẽ đưuọc kết quả :

```
Term      Doc_1  Doc_2
-------------------------
brown   |   X   |  X
quick   |   X   |
------------------------
Total   |   2   |  1
```

Ở doc1 có đọc tương thích cao hơn nên kết quả ở đây là doc1 .

[Source](https://www.elastic.co/guide/en/elasticsearch/guide/current/inverted-index.html)
### 3. Node
Node là trung tâm hoạt động của ELasticsearch, thực hiện lưu trữ dữ liệu để thực hiện đánh `index` của cluster, lưu trữ và tìm kiếm .
### 4. Cluster 
Là tập hợp các ` Node ` hoạt động cùng nhau và chia sẻ cùng thuộc tính ' cluster.name ' vì một để xác định mỗi node trên cluster chúng ta sẽ xác định bằng ` unique name `. Mỗi Cluster sẽ có một Node chính được gọi là master, các node có thể hoạt động trên  cùng một  server nhưng cần thiết hoạt động trên những servẻ khác nhau để phòng trườnghượp một server có vấn đề thì vẫn có Node hoạt động . Các Node có thể biết mình cùng một cluster  bằnghiao thức ` unicast `.

### 5. Shard

Shard là tập hợp con của các Index. Mỗi Index có thể có nhiều shard, vì mỗi shard ở trong node cho nên shảd là đối tương nhỏ nhất đóng vai trò lưu trữ dữ liệu.( thông thường chúng ta thường không làm việc trực tiếp với Shard và Elasticsearch đã hỗ trợ hết công việc giao tiếp )

Có hai loại : prrimary shard và replica shard 

#### 5.1 : Primary Shard 

là nơi đánh Index và chuyển nó đến Repica shard. Mặc định có 5 Primary shard cho 1 Index và mỗi Primary shard sẽ đi với 1 Relica shard ( Khi đã khởi tạo Index   chúng ta sẽ không thể thay đổi được số lượng Primary shard)
#### 5.2 Replica shard

Mỗi Primary shard có thể có hoặc k có Replica( mặc định primary sẽ đi với 1 replica hoắc chúng ta có thể cấu hình tăng thêm). vai trò của replica nhằm đảm bảo tính toàn vẹn cho dữ liệu ( khi mà primary có vấn đề thì dữ liệu sẽ được lấy từ replica )

### Mô hình kiến trúc của Cluster-Node-Shard 

<img src="../images/cluster-node-shard.png">

Mô hình chúng ta có 1 Cluster với 3 Node và Node master là Node 1. Tổng thể có 3 Primary Shard tương ứng với 3 Replica, các Primary có thể k cần đặt trên cùng một Node nhưng mỗi Primary và Replica cần đặt tại hai Node khác nhau để tránh trường hợp một Node bị vấn đê chúng ta có thể đảm bảo việc truy vấn dữ liệu vẫn diễn ra . Việc đặt Primary là ngẫu nhiên và chúng không nằm trên cùng một Node để giảm tải cho 1 Node và giúp phân tán dữ liệu một các đơn giản hơn.

### Các Elasticsearch lưu trữ dữ liệu 
Với mô hình hoạt động như trên khi có 1 document mới Elasticsearch sẽ thực hiện các công đoạn :
- chọn Shard để lưu dữ liệu.
```
shard = hash(routing) % number_of_primary_shards
```
hash là một hàm tính toán cố định của Elasticsearch, routing là 1 đoạn text duy nhất theo document, thường là _id của document đó. number_of_primary_shards là số lượng primary shard của cluster. Gía trị shard này là đi kèm với document, nó được dùng để xác định shard nào sẽ lưu document và cũng dùng để cho routing, vì bạn sẽ tìm document theo id của nó. Đó là lý do chúng ta không thể thay đổi số lượng primary shard, nếu không công thức trên sẽ không cho kết qủa giống như lúc ban đầu.
- Lưu trữ dữ liệu :
<img src ="../images/Elasticsearch-savedata.png">

    - Request được gửi đến master node, ở đây sẽ tính theo công thức phía trên và chuyển data đến Primary được xác nhận P0
    - Sau khi xác nhận được Primary master sẽ tiến hành gửi request sang cho node chứa primary .
    - Node 3 sẽ thực hiện request và xử lý dữ liệu sẽ đó gửi dữ liệu cho node 1,2 chứa replica shard để đảm bảo dữ liệu được thống nhất .

### Mô hình lấy dữ liệu 
<img src="../images/E-getdata.png">

- Như ghi dữ liệu Request sẽ được gửi đến Master Node và xác định primary shard cho document là P0

- Sau khi đã xác định được Primary chứa data và để giảm tập trung lại một Node nên việc lựa chọn node cho các thao tác đọc được thực hiện bởi thuật toán Round-robin. Và node được lựu chọn để thực hiện ở đây là Node 2. 

- R0 ở node2 sẽ trả kết quả về cho Master Node.



[- Source tham khảo](https://viblo.asia/p/elasticsearch-distributed-search-ZnbRlr6lG2Xo#replica-shard-6)

[- Source trên trang chủ ](https://www.elastic.co/guide/en/elasticsearch/guide/current/index.html)



