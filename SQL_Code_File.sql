select*from photos;
select*from users;
select*from comments;

/*Q2. We want to reward the user who has been around the longest, Find the 5 oldest users.*/

select * from users
order by created_at
limit 5;

/*Q3.To understand when to run the ad campaign, figure out the day of the week most users register on? */

select dayname(created_at) as Day, 
count(*) Most_registration
from users
group by Day
order by Most_registration desc;

/*Q4. To target inactive users in an email ad campaign, find the users who have never posted a photo.*/

select id ID,username USERNAME from users
where username in (select username from users left join
photos on users.id=photos.user_id
where photos.id is Null);

SELECT username
FROM users
LEFT JOIN photos
	ON users.id=photos.user_id
WHERE photos.id IS NULL;

/*Q5. Suppose you are running a contest to find out who got the most likes on a photo. Find out who won?*/

SELECT 
    COUNT(likes.user_id) AS MostLikes,
    photos.id,
    username,
    photos.image_url
FROM
    photos
        INNER JOIN
    likes ON likes.photo_id = photos.id
        INNER JOIN
    users ON photos.user_id = users.id
GROUP BY photos.id
ORDER BY MostLikes DESC
LIMIT 1;

/*Q6.The investors want to know how many times does the average user post.*/

select round((select count(*) from photos)/ (select count(*) from users),2);

/*Q7.A brand wants to know which hashtag to use on a post, and and find the top 5 most used hashtags.*/

SELECT 
    COUNT(pt.tag_id) Hashtag_total, t.tag_name, t.id
FROM
    tags t
        INNER JOIN
    photo_tags pt ON pt.tag_id = t.id
GROUP BY tag_name
ORDER BY Hashtag_total DESC
LIMIT 5;

SELECT 
	tags.tag_name,
	COUNT(*) AS total
FROM photo_tags
    JOIN tags
      ON photo_tags.tag_id= tags.id
GROUP BY tags.id
ORDER BY total DESC
LIMIT 5;

/*Q8. To find out if there are bots, find users who have liked every single photo on the site.*/

SELECT u.id,username, COUNT(u.id) As total_likes_by_user
FROM users u
JOIN likes l ON u.id = l.user_id
GROUP BY u.id
HAVING total_likes_by_user = (SELECT COUNT(*) FROM photos);


/*Q9. To know who the celebrities are, find users who have never commented on a photo.*/

select username, comment_text
from users u
left join comments c on u.id=c.user_id
group by u.id
having comment_text is null;


/*Q10. Now it's time to find both of them together, find the users who have never commented on any photo or have commented on every photo.*/

select username, comment_text,user_id
from users u
left join comments c on u.id=c.user_id
group by u.id
having comment_text is not null
UNION
select username, comment_text,user_id
from users u
left join comments c on u.id=c.user_id
group by u.id
having comment_text is null;

SELECT USERNAME,comment_text FROM
(SELECT username,comment_text
	FROM users
	LEFT JOIN comments ON users.id = comments.user_id
	GROUP BY users.id
	HAVING comment_text IS NOT NULL) AS total_number_users_with_comments
UNION
    SELECT USERNAME,comment_text FROM
(SELECT username,comment_text
	FROM users
	LEFT JOIN comments ON users.id = comments.user_id
	GROUP BY users.id
	HAVING comment_text IS NULL) AS total_number_users_with_comments;
    
