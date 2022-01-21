BEGIN TRANSACTION;

DROP TABLE IF EXISTS users;
DROP TABLE IF EXISTS restaurant_categories;
DROP TABLE IF EXISTS user_preferences;
DROP TABLE IF EXISTS restaurants;
DROP TABLE IF EXISTS invitations;
DROP TABLE IF EXISTS invitations_guests;
DROP TABLE IF EXISTS invitations_restaurants;
DROP SEQUENCE IF EXISTS seq_user_id;

CREATE SEQUENCE seq_user_id
  INCREMENT BY 1
  NO MAXVALUE
  NO MINVALUE
  CACHE 1;


CREATE TABLE users (
	user_id int DEFAULT nextval('seq_user_id'::regclass) NOT NULL,
	username varchar(50) NOT NULL,
	password_hash varchar(200) NOT NULL,
	role varchar(50) NOT NULL,
	CONSTRAINT PK_user PRIMARY KEY (user_id)
);

CREATE TABLE restaurant_categories (
        restaurant_category_id serial,
        indian int,
        breakfast int,
        mexican int,
        japanese int,
        italian int,
        seafood int,
        pizza int,
        chinese int,
        thai int,
        cajun int,
        
      CONSTRAINT pk_restaurant_categories PRIMARY KEY (restaurant_category_id)
);

CREATE TABLE guests (
        guest_id serial,
        guest_email_address varchar(255),
        guest_name varchar(50) NOT NULL,
        invitation_link_url varchar(255),
        is_invitation_link_url_live Boolean,
        
        CONSTRAINT pk_guests PRIMARY KEY (guest_id)
);

CREATE TABLE user_preferences (
        user_id int NOT NULL,
        rating decimal NULL,
        price char(4),
        restaurant_category_id int,
        
        constraint pk_user_preferences PRIMARY KEY (user_id),
        constraint fk_user_preferences_users FOREIGN KEY (user_id) references users (user_id),
        constraint fk_user_preferences_restaurant_categories FOREIGN KEY (restaurant_category_id) references restaurant_categories (restaurant_category_id)
);

CREATE TABLE restaurants (
        restaurant_tindr_number SERIAL,
        restaurant_yelp_id VARCHAR (50),
        restaurant_name VARCHAR(200),
        restaurant_image_url VARCHAR (255),
        restaurant_display_address VARCHAR (200),
        restaurant_display_phone varchar(15),
        restaurant_website_url varchar(255),
        restaurant_rating decimal(3,2),
        restaurant_price varchar(4),
        restaurant_category_id int,
        
        CONSTRAINT pk_restaurants PRIMARY KEY (restaurant_tindr_number),
        CONSTRAINT fk_restaurants_restaurant_categories FOREIGN KEY (restaurant_category_id) REFERENCES restaurant_categories (restaurant_category_id)
);


CREATE TABLE  invitations (
        invitation_id SERIAL,
        user_id int NOT NULL,
        event_location VARCHAR(100),
        event_guestnum int,
        event_unix_timestamp BIGINT,
        restaurant_1_thumbup int,
        restaurant_1_thumbdown int,
        restaurant_2_thumbup int,
        restaurant_2_thumbdown int,
        restaurant_3_thumbup int,
        restaurant_3_thumbdown int,
        
        constraint pk_invitation_id PRIMARY KEY (invitation_id),
        constraint fk_invitations_users FOREIGN KEY (user_id) references users (user_id)
);

CREATE TABLE invitations_guests (
        invitation_id int NOT NULL,
        guest_id int NOT NULL,
        
        constraint pk_invitations_guests PRIMARY KEY (invitation_id, guest_id),
        constraint fk_invitations_guests_invitations FOREIGN KEY (invitation_id) references invitations (invitation_id),
        constraint fk_invitations_guests_guests FOREIGN KEY (guest_id) references guests (guest_id)
);

CREATE TABLE invitations_restaurants (
        invitation_id int NOT NULL,
        restaurant_tindr_number int NOT NULL,
        
        CONSTRAINT pk_invitations_restaurants PRIMARY KEY (invitation_id, restaurant_tindr_number),
        CONSTRAINT fk_invitations_restaurants_invitations FOREIGN KEY (invitation_id) REFERENCES invitations (invitation_id),
        CONSTRAINT fk_invitations_restaurants_restaurants FOREIGN KEY (restaurant_tindr_number) REFERENCES restaurants (restaurant_tindr_number)
);




        

INSERT INTO users (username,password_hash,role) VALUES ('user','$2a$08$UkVvwpULis18S19S5pZFn.YHPZt3oaqHZnDwqbCW9pft6uFtkXKDC','ROLE_USER');
INSERT INTO users (username,password_hash,role) VALUES ('admin','$2a$08$UkVvwpULis18S19S5pZFn.YHPZt3oaqHZnDwqbCW9pft6uFtkXKDC','ROLE_ADMIN');


COMMIT TRANSACTION;
