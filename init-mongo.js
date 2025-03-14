db.getSiblingDB(process.env["MONGO_DBNAME"]).createUser({
    user: process.env["MONGO_USER"],
    pwd: process.env["MONGO_PASS"],
    roles: [{
        role: "dbOwner",
        db: process.env["MONGO_DBNAME"]
    }, {
        role: "dbOwner",
        db: process.env["MONGO_DBNAME"] + "_stat"
    }]
});
