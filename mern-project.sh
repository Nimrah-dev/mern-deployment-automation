
#!/bin/bash

echo "process start"

code_clone() {
    if [ -d Book-Store-Project ]; then
        echo "code already exists"
    else
        echo "code is clonning"
        git clone https://github.com/JosephDoUrden/Book-Store-Project.git || {
            echo "failed to clone"
            exit 1
        }
    fi
    cd Book-Store-Project || { echo "ERROR: folder mein nahi ja saki"; exit 1; }
}

backend_setup() {
    echo "setting up the backend"
    cd backend || { echo "ERROR: backend folder nahi mila"; exit 1; }
    npm install
}

mongodb_setup() {
    echo "mongodb setup"
    if command -v mongod &> /dev/null; then
        echo "MongoDB already installed hai"
    else
        echo "MongoDB install nahi hai, install kar rahe hain..."
        sudo apt install -y gnupg curl
        curl -fsSL https://pgp.mongodb.com/server-7.0.asc | sudo gpg -o /usr/share/keyrings/mongodb-server-7.0.gpg --dearmor
        echo "deb [ signed-by=/usr/share/keyrings/mongodb-server-7.0.gpg ] https://repo.mongodb.org/apt/ubuntu jammy/mongodb-org/7.0 multiverse" | sudo tee /etc/apt/sources.list.d/mongodb-org-7.0.list
        sudo apt update
        sudo apt install -y mongodb-org
        sudo systemctl start mongod
    fi

    if [ -f .env ]; then
        echo ".env is already created"
    else
        touch .env
        echo "mongoDBURL=mongodb://localhost:27017/bookstore" > .env
    fi
}

start_backend() {
	    echo "starting backend server"
	        nohup npm run dev &
		    echo "Backend background mein start ho gaya."
	    }
	    
	    frontend_setup() {
		    echo "starting the frontend"
		    cd ../frontend || { echo "ERROR: frontend folder nahi mila"; exit 1; }
		    npm install
		    nohup npm run dev &
		    echo "Frontend background mein start ho gaya."
	    }
code_clone
backend_setup
mongodb_setup
start_backend
frontend_setup

echo "process complete"
