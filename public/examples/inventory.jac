node product {
    has name;
    has stock = 0;

    can check with inventory entry {
        visitor.products[here.name] = here.stock;
    }

    can stock_up with purchase entry {
        here.stock += visitor.purchase_amount;
        std.log("Stock for " + here.name + " up to " + (here.stock).str);
    }

    can stock_down with sell entry {
        if(here.stock >= visitor.sell_amount) {
            here.stock -= visitor.sell_amount;
            std.log("Selling " + here.name + ": " + (visitor.sell_amount).str);
            std.log("Remaining stock: " + (here.stock).str);
        } else {
            std.log("Not enough stock for " + here.name);
        }
    }

}

node product_catalog;

edge category {
    has name;
}

graph shop {
    has anchor catalog;
    spawn {
        catalog = spawn node::product_catalog;

        apple = spawn node::product(name="apple");
        catalog +[category(name="fruit")]+> apple;

        banana = spawn node::product(name="banana");
        catalog +[category(name="fruit")]+> banana;

        notebook = spawn node::product(name="notebook");
        catalog +[category(name="supplies")]+> notebook;
    }
}

walker inventory {
    has products = {};
    root: take --> node::product_catalog;
    product_catalog: take --> node::product;

    with exit {
        report products;
    }
}

walker purchase {
    has product_category, product_name, purchase_amount;
    root: take --> node::product_catalog;
    product_catalog {
        take -[category(name==product_category)]-> node::product(name==product_name) else {
            new_product = spawn node::product(name=product_name);
            here +[category(name=product_category)]+> new_product;
            take new_product;
            std.log("New product: " + product_name);
        }
    }
}

walker sell {
    has product_category, product_name, sell_amount;
    root: take --> node::product_catalog;
    product_catalog {
        take -[category(name==product_category)]-> node::product(name==product_name) else {
            std.log("Sorry. We don't sell this product.");
        }
    }
}

walker init {
    root: spawn here ++> graph::shop;

    spawn here walker::purchase(product_category="fruit", product_name="apple", purchase_amount=10);
    spawn here walker::purchase(product_category="fruit", product_name="banana", purchase_amount=20);
    spawn here walker::purchase(product_category="supplies", product_name="notebook", purchase_amount=5);
    spawn here walker::inventory;

    spawn here walker::sell(product_category="fruit", product_name="apple", sell_amount=5);
    spawn here walker::sell(product_category="fruit", product_name="banana", sell_amount=10);
    spawn here walker::sell(product_category="supplies", product_name="notebook", sell_amount=2);
    spawn here walker::inventory;
}