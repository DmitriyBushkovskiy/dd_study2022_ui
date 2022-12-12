CREATE TABLE t_User(
	id					TEXT NOT NULL PRIMARY KEY
	,username			TEXT NOT NULL
	,birthDate			TEXT NOT NULL
	,avatarLink			TEXT
	,postsAmount 		INTEGER NOT NULL
    ,followedAmount 	iNTEGER NOT NULL
  	,followersAmount 	INTEGER NOT NULL
	,privateAccount 	INTEGER NOT NULL
	,colorAvatar 		iNTEGER NOT NULL
);
CREATE TABLE t_Post(
	id					TEXT NOT NULL PRIMARY KEY
	,[description]		TEXT
	,created 			TEXT NOT NULL
	,changed 			INTEGER NOT NULL
  	,likes 				INTEGER NOT NULL
  	,likedByMe 			INTEGER NOT NULL
	,authorId			TEXT NOT NULL
	,FOREIGN KEY(authorId) REFERENCES t_User(id)
);
CREATE TABLE t_PostContent(
	id					TEXT NOT NULL PRIMARY KEY
	,[name]				TEXT NOT NULL 
	,mimeType			TEXT NOT NULL 
	,postId				TEXT NOT NULL 
	,contentLink		TEXT NOT NULL 
    ,likes 				INTEGER NOT NULL
    ,likedByMe 			INTEGER NOT NULL
	,FOREIGN KEY(postId) REFERENCES t_Post(id)
);
CREATE TABLE t_Comment(
	id					TEXT NOT NULL PRIMARY KEY
	,commentText		TEXT NOT NULL 
	,created			TEXT NOT NULL 
	,changed 			INTEGER NOT NULL
	,likes 				INTEGER NOT NULL
    ,likedByMe 			INTEGER NOT NULL
	,authorId			TEXT NOT NULL 
	,postId				TEXT NOT NULL 
	,FOREIGN KEY(authorId) REFERENCES t_User(id)
	,FOREIGN KEY(postId) REFERENCES t_Post(id)
);