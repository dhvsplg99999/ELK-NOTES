## Logstash

Logstash là một phần mềm mã nguồn mở dùng để nhận log từ nhiều nơi khác nhau và nhiều kiểu khác nhau. Sau khi nhận log Logstash sẽ tiến hành phân tích log theo 3 bước Inputs => filters => outputs. 

Lý do cần phân tích log: vì khi nhận nhiều log từ nhiều nơi khác nhau mỗi log sẽ có một cấu trúc viết log khác nhau hoặc có thể là log không theo các cấu trúc cụ thể vì thế cần có một công đoạn phân tích các log đó theo một format nhất định để đễ dành hơn cho việc tìm kiếm, query log và hiển thị trên Kibana.

####  Mô hình hoạt động của Logstash

<img src="../images/logstash-workflow.jpg">

- Input : là tiến trình xác định nguồn lấy data cho Logstasg. Có nhiều cách để lấy log khác nhau :
    - File: là Logstash sẽ đọc data  từ File log của hệ thống.
    - Syslog: là Logstash sẽ lắng nghe cổng 514 để nhận các thông tin về syslog mà các client gửi lên server.
    - Beats : là tiến trình Logstash sẽ nhận log thông qua Beats ( có nhiều hình thức gửi nhưng chúng ta đang dùng là gửi bằng [Filebeats](./filebeats.md))
**Note**: Các cách gửi có thể gọi là các plugin của Input.

- Filter: là một tiến trình dùng để xử lý, phân tích logs ra những trường cố định hoặc biến một log không có cấu trúc cố định thành log có cấu trúc cố định. Cũng như Input , Filter cũng có các plugin mà điển hình hay sử dụng như sau :
    - grok: sử dụng các cú pháp (patterns) được cấu hình sẵn khi là tương thích với cú pháp sẽ lọc được ra các trường mình muốn lọc trong logs.
    - mutate : thực hiện các biến đổi về các trường của log ( ví dụ như có thể thau đổi được tên của trường dữ liệu `hostname` thành `shorthostname` )
    - drop: loại bỏ đi thông tin sự kiện của log ( ví dụ khi log gửi về có nhiều level khác nhau debug, info,.. khi bạn drop `debug` thì sẽ k hiển thị các thông tin có level `debug` nữa )
    - geoip: thêm thông tin về địa lý của địa chỉ ip .
**Note** : Chúng ta có thể xem thêm những plugin khác [tại đây ](https://www.elastic.co/guide/en/logstash/current/filter-plugins.html)

- Output: tiến trình này sẽ tiến hành ghi output ( những thông tin mà filter lọc được) lên plugin mà mình đã cấu hình ( có thể chạy nhiều plugin output nhưng chỉ khi tất cả các tiến trình hoành thành thì output mới được kết thúc).
Output plugin hay sử dụng :
    - Elasticsearch : chúng ta sẽ gửi dữ liệu vf lưu trữ tại Elasticsearch.
    - File : ghi thông tin có được lên một file trong ổ đĩa.

[BACK](../README.md)


