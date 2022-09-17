
---1.编写 SQL 查询，用以返回每种影片类型的电影总数。你的查询结果应该保存在一个名为“query1”的表中，该表有两个属性：“name”属性是影片类型列表，而“moviecount”是每个类型的电影计数列表
select genres.name,count(movies.movieid) moviecount
  into query1 
  from movies,hasagenre,genres
  where movies.movieid=hasagenre.movieid and hasagenre.genreid=genres.genreid
  group by genres.genreid,genres.name

---2.编写 SQL 查询，用以返回每种影片类型的平均评分。你的查询结果应该保存在一个名为“query2”的表中，该表有两个属性：“name”属性是影片类型列表，而“rating”是每种影片类型的平均评分
select genres.name,sum(ratings.rating)*1.0/count(genres.genreid) rating
  into query2 
  from movies,hasagenre,genres,ratings
  where movies.movieid=hasagenre.movieid and hasagenre.genreid=genres.genreid
        and movies.movieid=ratings.movieid
  group by genres.genreid,genres.name

---3.编写 SQL 查询，用以返回具有至少 10 次评分的电影。你的查询结果应该保存在一个名为“query3”的表中，该表有两个属性：“title”属性是影片名称列表，而“CountOfRatings”是评分列表
select movieid.title,count(ratings.rating) CountOfRatings
  into query3 
  from movies,ratings
  where movies.movieid=ratings.movieid
  group by movies.movieid,movieid.title
  having count(*)>10


---4.编写 SQL 查询，用以返回所有“Comedy”（喜剧）类型的电影，包括 movieid 和 title。你的查询结果应该保存在一个名为“query4”的表中，该表有两个属性：“movieid”属性是影片 id 列表，而“title”是电影名称列表
select distinct movies.movieid,movieid.title
  into query4 
  from movies,hasagenre,genres
  where movies.movieid=hasagenre.movieid and hasagenre.genreid=genres.genreid
        and genres.name='Comedy'

---5.编写 SQL 查询，用以返回每部影片的平均评分。你的查询结果应该保存在一个名为“query5”的表中，该表有两个属性：“title”属性是影片名称列表，而“average”是每部影片的平均评分
select movieid.title,sum(ratings.rating)*1.0/count(ratings.movieid) average
  into query5 
  from movies,ratings
  where movies.movieid=ratings.movieid
  group by movies.movieid,movieid.title

---6.编写 SQL 查询，用以返回所有“Comedy”（喜剧）类型电影的平均评分。你的查询结果应该保存在一个名为“query6”的表中，该表有一个属性：“average”
select sum(ratings.rating)*1.0/count(genres.genreid) average
  into query6 
  from movies,hasagenre,genres,ratings
  where movies.movieid=hasagenre.movieid and hasagenre.genreid=genres.genreid
        and movies.movieid=ratings.movieid
		and genres.name='Comedy'
  

---7.编写 SQL 查询，用以返回所有同时是“Comedy”（喜剧）和“Romance”（爱情）类型的影片的平均评分。你的查询结果应该保存在一个名为“query7”的表中，该表有一个属性：“average”
select sum(ratings.rating)*1.0/count(a.movieid) average
  into query7 
  from (select movies.movieid,movies.title from movies,hasagenre,genres
           where  movies.movieid=hasagenre.movieid and hasagenre.genreid=genres.genreid
		          and genres.name='Comedy') a
	  ,(select movies.movieid,movieid.title from movies,hasagenre,genres
           where  movies.movieid=hasagenre.movieid and hasagenre.genreid=genres.genreid
		          and genres.name='Romance') b
       ,ratings
  where a.movieid=b.movieid 
        and a.movieid=ratings.movieid
  

---8.编写 SQL 查询，用以返回所有是“Romance”（爱情），但不是“Comedy”（喜剧）类型的影片的平均评分。你的查询结果应该保存在一个名为“query8”的表中，该表有一个属性：“average”
select sum(ratings.rating)*1.0/count(a.movieid) average
  into query8
  from (select movies.movieid,movies.title from movies,hasagenre,genres
           where  movies.movieid=hasagenre.movieid and hasagenre.genreid=genres.genreid
		          and genres.name='Romance') a
	  ,(select movies.movieid,movieid.title from movies,hasagenre,genres
           where  movies.movieid=hasagenre.movieid and hasagenre.genreid=genres.genreid
		          and genres.name!='Comedy') b
       ,ratings
  where a.movieid=b.movieid 
        and a.movieid=ratings.movieid
  

---9.查找由这类用户（userId = v1）评分的所有电影。v1 是传递给 SQL 查询的整数参数。你的查询结果应该保存在一个名为“query9”的表中，该表有两个属性：“movieid”是由 userId v1 评分的 movieid 列表，而“rating”是 userId v1 对相应 movieid 的评分列表
select movieid.movieid,ratings.rating
   into query9
   from movies,ratings
   where movies.movieid=ratings.movieid
         and ratings.userid=@v1