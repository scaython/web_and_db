import express from "express";
import cors from "cors";
import mysql from 'mysql2';  // Change this line


const app = express();
app.use(cors()); // allow cors

app.use(express.static('website/public')); // serve static files

app.use(express.urlencoded({ extended: true }));


// Specify the views directory
app.set('views', 'website/views');

// use pug as view engine
app.set('view engine', 'pug'); 

const db = mysql.createPool({
    host: '127.0.0.1',
    user: 'ma',
    port: 3306,
    password: '2134',
    database: 'coursework'
}).promise();

//db.query = util.promisify(db.query).bind(db)

// Express routes

// Homepage shows a summary of data
app.get("/", async (req, res) => {
    try {
        // Fetch project data from the database
       
        const [projectCountRows] = await db.query("SELECT COUNT(*) AS projectCount FROM Project");
        const [userCountRows] = await db.query('SELECT COUNT(*) AS userCount FROM Student');
        const [totalFundingRows] = await db.query('SELECT SUM(Funding) AS totalFunding FROM Project');
        const [sponsorsRows] = await db.query('SELECT * FROM Sponsor');
        
        const userCount = userCountRows[0].userCount;
        const projectCount = projectCountRows[0].projectCount;
        const totalFunding = totalFundingRows[0].totalFunding;
        const sponsors = sponsorsRows;

        // Render the index view with the project data and sponsors
        res.render("index", { userCount, projectCount, totalFunding, sponsors });
    } catch (error) {
        console.error("Error fetching data:", error);
        res.status(500).send("Internal Server Error");
    }
});

// Shows all the projects in a table
app.get("/projects", async(req,res)=>{
    try{
        const [projects] = await db.query("SELECT * FROM Project");
        res.render("projects",{projects})
    }catch(error){
        console.error("Error fetching project data", error)
    }
})

// Shows all the blogs
app.get("/blogs", async(req,res)=>{
    try{
        const [blogs] = await db.query("SELECT * FROM Blog");
        res.render("blog",{blogs})
    }catch(error){
        console.error("Error fetching blog data", error)
    }
})

// View a blog
app.get("/blogs/:id", async (req, res) => {
    try {
        const blogID = req.params.id;
        // Fetch a single blog entry based on the provided ID
        const [blogRows] = await db.query("SELECT * FROM Blog WHERE BlogID = ?", [blogID]);

        // Check if a valid blog entry is found
        if (blogRows.length === 1) {
            const blog = blogRows[0];
            // Render the view-one template with the blog data
            res.render("view-blog", { blog });
        } else {
            // Render an error page or redirect to the blogs page
            res.status(404).send("Blog not found");
        }
    } catch (error) {
        console.error("Error fetching blog data:", error);
        res.status(500).send("Internal Server Error");
    }
});

// Edit data route
app.get("/blogs/edit/:id", async (req, res) => {
    try {
        const blogID = req.params.id;
        
        const [blogRows] = await db.query("SELECT * FROM Blog WHERE BlogID = ?", [blogID]);

        // Check if a valid blog entry is found
        if (blogRows.length === 1) {
            const blog = blogRows[0];

            const success = req.query.success === 'true';
            // Render the edit-one template with the blog data
            res.render("edit-blog", { blog,success });
        } else {
            // Render an error page or redirect to the blogs page
            res.status(404).send("Blog not found");
        }
    } catch (error) {
        console.error("Error fetching blog data:", error);
      //  res.status(500).send("Internal Server Error");
        success = false
        res.redirect("edit-blog", { blog,error });
    }
});


app.post("/blogs/edit/:id", async (req, res) => {
    try {
        const { BlogID, Title, Article } = req.body;
        
      

       
        const [updateResult] = await db.query("UPDATE Blog SET Title = ?, Article = ? WHERE BlogID = ?", [Title, Article, BlogID]);

        // Check if the update was successful
        if (updateResult.affectedRows === 1) {
            // Redirect the user to the "edit one" route with a success message
            const success = req.query.success === 'true';
            
            res.redirect(`/blogs/edit/${BlogID}?success=true`);
        } else {
            // Redirect the user to the "edit one" route with an error message
            res.redirect(`/blogs/edit/${BlogID}?error=true`);
        }
    } catch (error) {
        console.error("Error updating blog data:", error);
        const blogID = req.params.id;
        const [blogRows] = await db.query("SELECT * FROM Blog WHERE BlogID = ?", [blogID]);
        const blog = blogRows.length === 1 ? blogRows[0] : null;
        res.render("edit-blog", { blog, error});
    }
});

// Create a new data route
app.get("/join", (req, res) => {
    // Render the join page
    res.render("join", { success: req.query.success, error: req.query.error });
});

app.post("/join", async (req, res) => {
    try {
        // Extract student details from the form submission
        const { urn, firstName, lastName, dob, phone, course, type } = req.body;

        // Insert the new student entry into the database
        const [insertResult] = await db.query(
            "INSERT INTO Student (URN,Stu_FName, Stu_LName, Stu_DOB, Stu_Phone, Stu_Course, Stu_Type) VALUES (?,?, ?, ?, ?, ?, ?)",
            [urn, firstName, lastName, dob, phone, course, type]
        );
        console.log("Received form submission:", req.body);
        // Check if the insertion was successful
        if (insertResult.affectedRows === 1) {
            // Redirect the user to a success page or another appropriate page
            res.redirect("/join?success=Join successful");
        } else {
            // Render an error page or redirect to the join page with an error message
            res.redirect("/join?error=Join failed");
        }
    } catch (error) {
        console.error("Error joining:", error);
        // Render an error page or redirect to the join page with an error message
        res.redirect("/join?error=Join failed");
    }
});

// Before starting the application you may need to build tailwind with the following command:
// npx tailwindcss -i website/public/css/styles.css -o website/public/css/output.css --watch
// Also run the following command if neccesary:
// npm run build:css
// ignore daisyUI package related errors in terminal as it is included as cdn in output.css build file
const PORT = 8000;
app.listen(PORT, () => {
    console.log(`Server is running on : http://localhost:${PORT}`);
});
