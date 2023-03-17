from flask import Flask, render_template, request, redirect, url_for
import sqlite3 as sql
import csv
import random
from datetime import datetime
from flask_admin import Admin
from flask_admin.contrib.sqla import ModelView

app = Flask(__name__)

host = 'http://127.0.0.1:5000/'
connection = sql.connect('database.db')

email_global = ''
logged_in = False
seller_global = False
item1_global = ""
item2_global = ""
cart = []

# admin = Admin(app, name='Dashboard')
# admin.add_view(ModelView(users, db.session))


@app.route('/', methods = ['POST', 'GET'])
def index(string = ""):
    if request.method=="POST":
        global logged_in 
        logged_in = True
        email, password = request.form['email'], request.form['password']
        global email_global
        email_global = email
        global seller_global
        seller_global = checkSeller(email_global)
        print(email, password)
        checked = check(email,password)
        string = ""
        if checked:
            string = "Successefully logged in"
            return redirect('/home')
        else:
            string = "Incorrect username or password"
        print(string)
    return render_template('index.html', string=string)

@app.route('/signout', methods = ['GET'])
def logout():
    global logged_in
    logged_in = False
    global email_global
    email_global = ""
    global seller_global
    seller_global = False
    return redirect('/')

# @app.route('/shoppingCart', methods = ['GET', 'POST'])
# def shoppingCart():
#     if request.method=="POST":
#         pass
#     global cart
#     return render_template('shoppingCart.html', seller = seller_global, email = email_global, cart = cart)
    
@app.route('/info', methods = ['POST', 'GET'])
def info():
    string = ""
    if request.method == 'POST':
        password = request.form['password']
        update_password(password, email_global)
    if logged_in:
        lst = info_func(email_global)
        lst = lst[0]
        print(lst, "lst")
        dic_1 = { "First name" : lst[0], "Last name" : lst[1], "Email" : lst[2], "Age": lst[3], "Gender" : lst[4] }
        dic_2 = {"Street num": lst[5], "Street name":lst[6], "City": lst[7], "State id": lst[8], "Zipcode": lst[9]}
        dic_3 = {"Street num": lst[10], "Street name": lst[11], "City": lst[12], "State id": lst[13], "Zipcode": lst[14]}
        dic_4 = {"Credit Card Num": "****-****-****-"+lst[15][-4:]}
        return render_template('info.html', seller = seller_global, email = email_global, userInfo = dic_1, home_addr = dic_2, billing_addr = dic_3, credit_card = dic_4)
    else:
        return redirect('/notFound')


def update_password(password, email):
    connection = sql.connect('database.db')
    cursor = connection.execute('UPDATE users SET password = ? WHERE email = ?;', (password, email, ))
    connection.commit()

@app.route('/productListing', methods = ['GET', 'POST'])
def productListing():
    url = "/productListing"
    productBool = False
    lst = productsCats("Root")
    products = []
    if request.method == 'POST':
        form_name = request.form['form-name']
        if form_name == 'form1':
            productBool = True
            selectedItem = request.form['search']
            products = search(selectedItem)
        else:
            print("else")
            selectedItem = request.form['dropdown']
            global item1_global
            item1_global = selectedItem
            productBool = True
            if selectedItem!="All":
                return redirect('/productListing2')
            products = returnProducts("All", None, None)
    return render_template('productListing.html', seller = seller_global, email = email_global, lst = lst, products = products, productBool = productBool, url = url)


@app.route('/productListing2', methods = ['GET', "POST"])
def productListing2():
    url = "/productListing2"
    item = item1_global
    productBool = False
    lst = productsCats(item)
    products = []
    if request.method == 'POST':
        selectedItem = request.form['dropdown']
        productBool = True
        global item2_global
        item2_global = selectedItem
        if selectedItem!="All":
            return redirect('/productListing3')
        products = returnProducts(item, "All", None)
    return render_template('productListing.html', seller = seller_global, email = email_global, lst = lst, products = products, productBool = productBool, url = url)

@app.route('/productListing3', methods = ['GET', "POST"])
def productListing3():
    url = "/productListing3"
    item = item2_global
    productBool = False
    lst = productsCats(item)
    products = []
    if request.method == "POST":
        selectedItem = request.form['dropdown']
        productBool = True
        products = returnProducts(None, item, selectedItem)
    return render_template('productListing.html', seller = seller_global, email = email_global, lst = lst, products = products, productBool = productBool, url = url)

def returnProducts(parent_c, child_c, third_c):
    connection = sql.connect('database.db')
    if parent_c =='All':
        cursor = connection.execute("SELECT p.title, p.product_name, p.price, p.quantity, p.listing_id FROM Product_Listing p;")
    elif child_c == 'All':
        cursor = connection.execute("SELECT p.title, p.product_name, p.price, p.quantity, p.listing_id FROM Product_Listing p WHERE p.category=?;",(parent_c,))
    else:
        if third_c =='All':
            cursor = connection.execute("SELECT p.title, p.product_name, p.price, p.quantity, p.listing_id FROM Product_Listing p WHERE p.category=?;",(child_c,))
        else:
            cursor = connection.execute("SELECT p.title, p.product_name, p.price, p.quantity, p.listing_id FROM Product_Listing p WHERE p.category=?;",(third_c,))

    data = cursor.fetchall()
    print(data, 'results')
    connection.commit()
    return data


def productsCats(x):
    connection = sql.connect('database.db')
    cursor = connection.execute("SELECT c.category_name FROM Categories c WHERE c.parent_category = ?;", (x, ))
    connection.commit()
    return cursor.fetchall()

def retrieveProductInfo(product_id):
    connection = sql.connect('database.db')
    cursor = connection.execute("SELECT * FROM Product_Listing p where p.listing_id=?;", (product_id,))
    data = cursor.fetchall()
    connection.commit()
    return data

def search(value):
    connection = sql.connect('database.db')
    cursor = connection.execute("SELECT p.title, p.product_name, p.price, p.quantity, p.listing_id FROM Product_Listing p WHERE p.title LIKE ?;",('%'+value+'%',))
    data1 = cursor.fetchall()
    cur = connection.execute("SELECT p.title, p.product_name, p.price, p.quantity, p.listing_id FROM Product_Listing p WHERE p.product_name LIKE ?;",('%'+value+'%',))
    data2 = cursor.fetchall()
    cur2 = connection.execute("SELECT p.title, p.product_name, p.price, p.quantity, p.listing_id FROM Product_Listing p WHERE p.category LIKE ?;",('%'+value+'%',))
    data3 = cursor.fetchall()
    data = data1 + data2 + data3
    print(data)
    return data

@app.route('/publishProduct', methods = ['GET', 'POST'])
def publishProduct():
    string = ""
    if request.method == 'POST':
        string = "Successfully added"
        title = request.form['title']
        product_name = request.form['name']
        product_description = request.form['description']
        category = request.form['category']
        price = request.form['price']
        quantity = request.form['qty']
        insertProduct(email_global, category, title, product_name, product_description, price, quantity)
    connection = sql.connect('database.db')
    cursor = connection.execute("SELECT DISTINCT c.category_name FROM Categories c;")
    category = cursor.fetchall()
    connection.commit()
    return render_template('publishProduct.html', seller = seller_global, email = email_global, category=category)

def insertProduct(seller_email, category, title, product_name, product_description, price, quantity):
    connection = sql.connect('database.db')
    res = [2, 1]
    while len(res)!=0:
        listing_ID = random.randint(0,1000)
        cur = connection.execute('SELECT * FROM Product_Listing p WHERE p.listing_ID = ?;', (listing_ID,))
        res = cur.fetchall()
    cursor = connection.execute('INSERT INTO Product_Listing (seller_email, listing_ID, category, title, product_name, product_description, price, quantity) VALUES (?,?,?,?,?,?,?,?)', (seller_email, listing_ID, category, title, product_name, product_description, price, quantity, ))
    cur = connection.execute('SELECT * FROM Product_Listing p WHERE p.listing_ID = ?;', (listing_ID,))
    print(cur.fetchall())
    connection.commit()

@app.route('/productDetails/<product_id>', methods = ['GET']) 
def productDetails(product_id=None):
    if product_id:
        product = retrieveProductInfo(product_id)
        review = getReview(product_id)
        return render_template('productDetails.html', seller = seller_global, email = email_global, product = product[0], review = review)
    return redirect('/notFound')

@app.route('/buy/<product_id>', methods = ['POST', 'GET'])
def placeOrder(product_id=None):
    if request.method == 'GET':
        if product_id:
            print("that condition")
            product = retrieveProductInfo(product_id)[0]
            qty = product[7]
            inStock = False
            if qty>0:
            #check if it is in stock
                inStock = True
            
            return render_template('order.html', inStock = inStock, post=False, order = [], product_id = product_id)
        else:
            return redirect('/notFound')
    else:
        if product_id:
            print("This condition")
            product = retrieveProductInfo(product_id)[0]
            qty = product[7]
            seller_email = product[0]
            price = product[6]
            transaction_id = orderProduct(seller_email, product_id, qty, price)
            #handle stock reduction and everything
            inStock = True
            return render_template('order.html', inStock = inStock, post = True, transaction_id = transaction_id, product_id = product_id, seller_email = seller_email)
        else:
            return redirect('/notFound')

@app.route('/rate/<username>', methods = ['POST', 'GET'])
def rateSeller(username=None):
    if username:
        string = ""
        if request.method =="POST":
            print("working")
            string = "Succesfully submitted your rating"
            rating = request.form['rating']
            rating_desc = request.form['desc']
            insertRating(username,rating,rating_desc)
        rating = getRating(username)
        return render_template('rating.html', string=string, seller = seller_global, email = email_global, rating=rating[0], username = username)
    return redirect('/notFound')

@app.route('/review/<product_id>', methods = ['POST', 'GET'])
def reviewProduct(product_id=None):
    if product_id:
        string=""
        if request.method=="POST":
            string = "Succesfully submitted your review"
            review = request.form['desc']
            seller_email = retrieveSellerEmail(product_id)
            insertReview(review, product_id, seller_email)
            return redirect(url_for('productDetails', product_id=product_id))
        return render_template('review.html', string=string, seller=seller_global, email=email_global, product_id = product_id)
    return redirect('/notFound')

def insertRating(seller, rating, rating_desc):
    if seller!=email_global:
        connection = sql.connect('database.db')
        now = datetime.now()
        date = now.strftime("%m/%d/%Y")
        cursor = connection.execute('INSERT INTO Ratings (buyer_email, seller_email, date, rating, rating_desc) VALUES (?,?,?,?,?)',(email_global, seller, date, rating, rating_desc))
        connection.commit()

def retrieveSellerEmail(product_id):
    connection = sql.connect('database.db')
    cursor = connection.execute("SELECT p.seller_email FROM Product_Listing p WHERE p.listing_ID = ?",(product_id,))
    data = cursor.fetchall()
    print("data", data)
    email =""
    if len(data)!=0:
        email = data[0][0]
    connection.commit()
    return email

def getRating(seller):
    connection = sql.connect('database.db')
    now = datetime.now()
    date = now.strftime("%m/%d/%Y")
    cursor = connection.execute("SELECT AVG(r.rating) FROM Ratings r WHERE r.seller_email = ?", (seller,))
    data = cursor.fetchall()
    connection.commit()
    return data

def insertReview(review_desc, product_id, seller):
    connection = sql.connect('database.db')
    cursor = connection.execute('INSERT INTO Reviews (buyer_email, seller_email, listing_ID, review_desc) VALUES (?,?,?,?)', (email_global, seller, product_id, review_desc ))
    cur = connection.execute('SELECT * FROM Reviews r WHERE r.listing_ID = ?', (product_id,))
    print(cur.fetchall(), "interesting")
    connection.commit()

def getReview(product_id):
    connection = sql.connect('database.db')
    cursor = connection.execute('SELECT r.buyer_email, r.review_desc FROM Reviews r WHERE r.listing_ID = ?', (product_id,))
    data = cursor.fetchall()
    print(data)
    connection.commit()
    return data

def orderProduct(seller_email, product_id, qty, price):
    new_qty = int(qty)-1
    print(new_qty, "new quant")
    connection = sql.connect('database.db')
    cursor = connection.execute("UPDATE Product_Listing SET quantity = ? WHERE listing_id = ?;", (new_qty,product_id,))
    curr = connection.execute("SELECT * FROM Product_Listing WHERE listing_id = ?;", (product_id,))
    print(curr.fetchall())
    data_2 = [1, 2]
    while len(data_2)!=0:
        transaction_id = random.randint(1250, 1500)
        cur = connection.execute("SELECT * FROM Orders o WHERE o.transaction_ID = ?;", (transaction_id,))
        data_2 = cur.fetchall()
    now = datetime.now()
    date = now.strftime("%m/%d/%Y")
    cursor2 = connection.execute('INSERT INTO Orders (transaction_ID, seller_email, listing_ID, buyer_email, date, quantity, payment) VALUES (?,?,?,?,?,?,?);', (transaction_id, seller_email, product_id, email_global, date, qty, price,))
    connection.commit()
    return transaction_id



@app.route('/home', methods = ['GET'])
def home():
    if logged_in:
        return render_template('home.html', seller=seller_global, email = email_global)
    else:
        return redirect('/notFound')


# @app.route('/review', methods = ['POST', 'GET'])
# def reviewRating():
#     ratings = None
#     reviews = None
#     if request.method == 'GET':
#         return render_template('ratingsReviews.html', ratings = ratings, reviews = reviews)
#     else:
#         #handle form data
#         #add review and rating
#         return render_template('ratingsReviews.html', ratings = ratings, reviews = reviews)


@app.route('/notFound', methods = ['GET'])
def pageNotFound():
    return render_template('pageNotFound.html')

def info_func(email):
    connection = sql.connect('database.db')
    cursor = connection.execute(
    "SELECT b.first_name, b.last_name, b.email, b.age, b.gender, h.street_num, h.street_name, hz.city, hz.state_id, h.zipcode, ba.street_num, ba.street_name, baz.city, baz.state_id, ba.zipcode, c.credit_card_num FROM Buyers b, Address h, Address ba, ZipcodeInfo hz, ZipcodeInfo baz, CreditCard C WHERE b.email = ? AND h.address_id = b.home_address_id AND hz.zipcode = h.zipcode AND ba.address_id = b.billing_address_id AND baz.zipcode = ba.zipcode AND c.owner_email = ?;", (email,email, ))
    data = cursor.fetchall()
    connection.commit()
    return data


def checkSeller(email):
    connection = sql.connect('database.db')
    cursor = connection.execute("SELECT * FROM Sellers s WHERE s.email = ?", (email,))
    data = cursor.fetchall()
    connection.commit()
    if len(data)==0:
        return False
    else:
        return True

def check(email, password):
    connection = sql.connect('database.db')
    cursor = connection.execute("SELECT * FROM users u WHERE u.email = ?;", (email,))
    data = cursor.fetchall()
    connection.commit()
    if len(data)==0:
        return False
    elif data[0][1]==password:
        return True
    return False

def hash(password):
    pass

def populate_data():
    connection = sql.connect('database.db')
    cursor = connection.cursor()

    connection.execute("CREATE TABLE IF NOT EXISTS users(email TEXT, password TEXT, PRIMARY KEY(email));")
    file = open('Users.csv')
    contents = csv.reader(file)
    insert_records = 'INSERT OR IGNORE INTO users (email, password) VALUES (?,?)'
    cursor.executemany(insert_records, contents)


    connection.execute('CREATE TABLE IF NOT EXISTS ZipcodeInfo(zipcode REAL, city TEXT, state_id TEXT, population TEXT, density REAL, county_name TEXT, timezone TEXT, PRIMARY KEY(zipcode));')
    file = open('Zipcode_Info.csv')
    contents = csv.reader(file)
    insert_records = 'INSERT OR IGNORE INTO ZipcodeInfo (zipcode, city, state_id, population, density, county_name, timezone) VALUES (?,?,?,?,?,?,?)'
    cursor.executemany(insert_records, contents)
    c = connection.execute("SELECT * FROM ZipcodeInfo;")
    print(c.fetchall())

    cursor.execute('CREATE TABLE IF NOT EXISTS Address(address_id TEXT, zipcode REAL, street_num REAL, street_name TEXT, PRIMARY KEY(address_id), FOREIGN KEY(zipcode) REFERENCES ZipcodeInfo(zipcode));')
    file = open('Address.csv')
    contents = csv.reader(file)
    insert_records = 'INSERT OR IGNORE INTO Address (address_id, zipcode, street_num, street_name) VALUES (?,?,?,?)'
    cursor.executemany(insert_records, contents)

    cursor.execute('CREATE TABLE IF NOT EXISTS Buyers(email TEXT, first_name TEXT, last_name TEXT, gender TEXT, age REAL, home_address_id REAL, billing_address_id REAL, PRIMARY KEY(email),FOREIGN KEY(email) REFERENCES Users(email), FOREIGN KEY(home_address_id) REFERENCES Address(address_id), FOREIGN KEY(billing_address_id) REFERENCES Address(address_id));')
    file = open('Buyers.csv')
    contents = csv.reader(file)
    insert_records = 'INSERT OR IGNORE INTO Buyers (email, first_name, last_name, gender, age, home_address_id, billing_address_id) VALUES (?,?,?,?,?,?,?)'
    cursor.executemany(insert_records, contents)

    connection.execute('CREATE TABLE IF NOT EXISTS CreditCard(credit_card_num TEXT, card_code TEXT, expire_month TEXT, expire_year TEXT, card_type TEXT, owner_email TEXT, PRIMARY KEY(credit_card_num), FOREIGN KEY(owner_email) REFERENCES Buyers(email));')
    file = open('Credit_Cards.csv')
    contents = csv.reader(file)
    insert_records = 'INSERT OR IGNORE INTO CreditCard (credit_card_num, card_code, expire_month, expire_year, card_type, owner_email) VALUES (?,?,?,?,?,?)'
    cursor.executemany(insert_records, contents)


    connection.execute('CREATE TABLE IF NOT EXISTS Sellers(email TEXT, routing_number INTEGER, account_number TEXT, balance REAL, PRIMARY KEY (email), FOREIGN KEY(email) REFERENCES Buyers(email));')
    file = open('Sellers.csv')
    contents = csv.reader(file)
    insert_records = 'INSERT OR IGNORE INTO Sellers (email, routing_number, account_number, balance) VALUES (?,?,?,?)'
    cursor.executemany(insert_records, contents)

    connection.execute('CREATE TABLE IF NOT EXISTS Vendors(email TEXT, business_name TEXT, business_address_ID TEXT, customer_service_number TEXT, PRIMARY KEY(email), FOREIGN KEY(email) REFERENCES Sellers(email),FOREIGN KEY(business_address_ID) REFERENCES Address(address_id));')
    file = open('Local_Vendors.csv')
    contents = csv.reader(file)
    insert_records = 'INSERT OR IGNORE INTO Vendors (email, business_name, business_address_ID, customer_service_number) VALUES (?,?,?,?)'
    cursor.executemany(insert_records, contents)


    cursor.execute('CREATE TABLE IF NOT EXISTS Categories(parent_category TEXT, category_name TEXT, PRIMARY KEY(category_name));')
    file = open('Categories.csv')
    contents = csv.reader(file)
    insert_records = 'INSERT OR IGNORE INTO Categories (parent_category, category_name) VALUES (?,?)'
    cursor.executemany(insert_records, contents)

    connection.execute('CREATE TABLE IF NOT EXISTS Product_Listing(seller_email TEXT, listing_ID REAL, category TEXT, title TEXT, product_name TEXT, product_description TEXT, price REAL, quantity REAL, PRIMARY KEY(seller_email, listing_id));')
    file = open('Product_Listing.csv')
    contents = csv.reader(file)
    insert_records = 'INSERT OR IGNORE INTO Product_Listing (seller_email, listing_ID, category, title, product_name, product_description, price, quantity) VALUES (?,?,?,?,?,?,?,?)'
    cursor.executemany(insert_records, contents)

    connection.execute('CREATE TABLE IF NOT EXISTS Orders(transaction_ID REAL, seller_email TEXT, listing_ID REAL, buyer_email TEXT, date TEXT, quantity REAL, payment REAL, PRIMARY KEY(transaction_id), FOREIGN KEY(seller_email, listing_id) REFERENCES Product_Listings(seller_email, listing_id), FOREIGN KEY(buyer_email) REFERENCES Buyers(email));')
    file = open('Orders.csv')
    contents = csv.reader(file)
    insert_records = 'INSERT OR IGNORE INTO Orders (transaction_ID, seller_email, listing_ID, buyer_email, date, quantity, payment) VALUES (?,?,?,?,?,?,?)'
    cursor.executemany(insert_records, contents)

    connection.execute('CREATE TABLE IF NOT EXISTS Reviews(buyer_email TEXT, seller_email TEXT, listing_ID TEXT, review_desc TEXT, PRIMARY KEY(buyer_email, seller_email, listing_id), FOREIGN KEY(buyer_email) REFERENCES Buyers(email), FOREIGN KEY(seller_email, listing_id) REFERENCES Product_Listings(seller_email, listing_id));')
    file = open('Reviews.csv')
    contents = csv.reader(file)
    insert_records = 'INSERT OR IGNORE INTO Reviews (buyer_email, seller_email, listing_ID, review_desc) VALUES (?,?,?,?)'
    cursor.executemany(insert_records, contents)

    connection.execute('CREATE TABLE IF NOT EXISTS Ratings(buyer_email TEXT, seller_email TEXT, date TEXT, rating INTEGER, rating_desc TEXT, PRIMARY KEY(buyer_email, seller_email, date), FOREIGN KEY(buyer_email) REFERENCES Buyers(email), FOREIGN KEY(seller_email) REFERENCES Sellers(email));')
    file = open('Ratings.csv')
    contents = csv.reader(file)
    insert_records = 'INSERT OR IGNORE INTO Ratings (buyer_email, seller_email, date, rating, rating_desc) VALUES (?,?,?,?,?)'
    cursor.executemany(insert_records, contents)
    
    connection.commit()
    return

populate_data()

if __name__ == "__main__":
    app.run()


