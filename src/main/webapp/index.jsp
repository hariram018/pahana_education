<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Pahana Edu Bookshop - Home</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        :root {
            --primary: #4361ee;
            --secondary: #3f37c9;
            --accent: #4895ef;
            --light: #f8f9fa;
            --dark: #212529;
            --success: #4cc9f0;
            --warning: #f7b801;
            --danger: #f72585;
        }

        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            color: #333;
            overflow-x: hidden;
        }

        /* Navigation */
        .navbar {
            background: white;
            box-shadow: 0 2px 15px rgba(0, 0, 0, 0.1);
            padding: 15px 0;
        }

        .navbar-brand {
            font-weight: 800;
            font-size: 24px;
            color: var(--primary);
        }

        .nav-link {
            font-weight: 600;
            color: #495057;
            margin: 0 10px;
            transition: all 0.3s;
        }

        .nav-link:hover {
            color: var(--primary);
        }

        .btn-primary {
            background: linear-gradient(to right, var(--primary), var(--secondary));
            border: none;
            border-radius: 8px;
            padding: 10px 20px;
            font-weight: 600;
            transition: all 0.3s;
        }

        .btn-primary:hover {
            transform: translateY(-2px);
            box-shadow: 0 5px 15px rgba(67, 97, 238, 0.4);
        }

        /* Hero Section */
        .hero {
            background: linear-gradient(rgba(67, 97, 238, 0.9), rgba(63, 55, 201, 0.9)), url('https://images.unsplash.com/photo-1507842217343-583bb7270b66?ixlib=rb-4.0.3') center/cover;
            color: white;
            padding: 100px 0;
            text-align: center;
        }

        .hero h1 {
            font-size: 3.5rem;
            font-weight: 800;
            margin-bottom: 20px;
        }

        .hero p {
            font-size: 1.2rem;
            max-width: 700px;
            margin: 0 auto 30px;
        }

        /* Features Section */
        .features {
            padding: 80px 0;
        }

        .section-title {
            text-align: center;
            margin-bottom: 50px;
        }

        .section-title h2 {
            font-weight: 800;
            color: var(--dark);
            position: relative;
            display: inline-block;
            margin-bottom: 15px;
        }

        .section-title h2::after {
            content: '';
            position: absolute;
            bottom: -10px;
            left: 50%;
            transform: translateX(-50%);
            width: 60px;
            height: 4px;
            background: var(--primary);
            border-radius: 2px;
        }

        .feature-card {
            background: white;
            border-radius: 15px;
            padding: 30px;
            box-shadow: 0 5px 20px rgba(0, 0, 0, 0.05);
            transition: all 0.3s;
            height: 100%;
            text-align: center;
        }

        .feature-card:hover {
            transform: translateY(-10px);
            box-shadow: 0 15px 30px rgba(0, 0, 0, 0.1);
        }

        .feature-icon {
            width: 80px;
            height: 80px;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            margin: 0 auto 20px;
            font-size: 30px;
            background: rgba(67, 97, 238, 0.1);
            color: var(--primary);
        }

        /* Books Section */
        .books {
            background: #f8f9fa;
            padding: 80px 0;
        }

        .book-card {
            background: white;
            border-radius: 15px;
            overflow: hidden;
            box-shadow: 0 5px 15px rgba(0, 0, 0, 0.05);
            transition: all 0.3s;
            margin-bottom: 30px;
        }

        .book-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 10px 25px rgba(0, 0, 0, 0.1);
        }

        .book-img {
            height: 250px;
            overflow: hidden;
        }

        .book-img img {
            width: 100%;
            height: 100%;
            object-fit: cover;
            transition: all 0.5s;
        }

        .book-card:hover .book-img img {
            transform: scale(1.05);
        }

        .book-info {
            padding: 20px;
        }

        .book-title {
            font-weight: 700;
            margin-bottom: 10px;
            color: var(--dark);
        }

        .book-author {
            color: #6c757d;
            margin-bottom: 15px;
        }

        .book-price {
            font-weight: 800;
            color: var(--primary);
            font-size: 1.2rem;
        }

        /* Testimonials */
        .testimonials {
            padding: 80px 0;
        }

        .testimonial-card {
            background: white;
            border-radius: 15px;
            padding: 30px;
            box-shadow: 0 5px 15px rgba(0, 0, 0, 0.05);
            margin: 20px 0;
            position: relative;
        }

        .testimonial-card::before {
            content: '\201C';
            position: absolute;
            top: 20px;
            left: 20px;
            font-size: 60px;
            color: rgba(67, 97, 238, 0.1);
            font-family: Arial;
        }

        .testimonial-text {
            font-style: italic;
            margin-bottom: 20px;
            position: relative;
            z-index: 1;
        }

        .testimonial-author {
            display: flex;
            align-items: center;
        }

        .testimonial-author img {
            width: 50px;
            height: 50px;
            border-radius: 50%;
            margin-right: 15px;
            object-fit: cover;
        }

        /* Footer */
        .footer {
            background: var(--dark);
            color: white;
            padding: 60px 0 30px;
        }

        .footer-title {
            font-weight: 700;
            margin-bottom: 25px;
            font-size: 1.2rem;
        }

        .footer-links {
            list-style: none;
            padding: 0;
        }

        .footer-links li {
            margin-bottom: 10px;
        }

        .footer-links a {
            color: rgba(255, 255, 255, 0.7);
            text-decoration: none;
            transition: all 0.3s;
        }

        .footer-links a:hover {
            color: white;
            padding-left: 5px;
        }

        .social-icons {
            display: flex;
            gap: 15px;
        }

        .social-icons a {
            width: 40px;
            height: 40px;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            background: rgba(255, 255, 255, 0.1);
            color: white;
            transition: all 0.3s;
        }

        .social-icons a:hover {
            background: var(--primary);
            transform: translateY(-3px);
        }

        .copyright {
            text-align: center;
            padding-top: 30px;
            margin-top: 30px;
            border-top: 1px solid rgba(255, 255, 255, 0.1);
            color: rgba(255, 255, 255, 0.7);
        }

        /* Responsive adjustments */
        @media (max-width: 768px) {
            .hero h1 {
                font-size: 2.5rem;
            }

            .hero p {
                font-size: 1rem;
            }
        }
    </style>
</head>
<body>
<!-- Navigation -->
<nav class="navbar navbar-expand-lg navbar-light sticky-top">
    <div class="container">
        <a class="navbar-brand" href="#">
            <i class="fas fa-book-reader me-2"></i>Pahana Edu Bookshop
        </a>
        <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarNav">
            <span class="navbar-toggler-icon"></span>
        </button>
        <div class="collapse navbar-collapse" id="navbarNav">
            <ul class="navbar-nav ms-auto">
                <li class="nav-item">
                    <a class="nav-link active" href="#">Home</a>
                </li>
                <li class="nav-item">
                    <a class="nav-link" href="#">Books</a>
                </li>
                <li class="nav-item">
                    <a class="nav-link" href="#">Categories</a>
                </li>
                <li class="nav-item">
                    <a class="nav-link" href="#">About Us</a>
                </li>
                <li class="nav-item">
                    <a class="nav-link" href="#">Contact</a>
                </li>
            </ul>
            <div class="ms-lg-3 mt-3 mt-lg-0">
                <a href="login" class="btn btn-primary">Login / Register</a>
            </div>
        </div>
    </div>
</nav>

<!-- Hero Section -->
<section class="hero">
    <div class="container">
        <h1>Discover Your Next Favorite Book</h1>
        <p>Pahana Edu Bookshop offers a wide selection of educational books, textbooks, and resources for students and educators alike.</p>
        <a href="#" class="btn btn-light btn-lg">Browse Collection</a>
    </div>
</section>

<!-- Features Section -->
<section class="features">
    <div class="container">
        <div class="section-title">
            <h2>Why Choose Us</h2>
            <p>We provide the best resources for your educational journey</p>
        </div>
        <div class="row">
            <div class="col-md-4 mb-4">
                <div class="feature-card">
                    <div class="feature-icon">
                        <i class="fas fa-shipping-fast"></i>
                    </div>
                    <h3>Fast Delivery</h3>
                    <p>Get your books delivered to your doorstep within 2-3 business days</p>
                </div>
            </div>
            <div class="col-md-4 mb-4">
                <div class="feature-card">
                    <div class="feature-icon">
                        <i class="fas fa-tags"></i>
                    </div>
                    <h3>Best Prices</h3>
                    <p>Enjoy competitive prices and regular discounts on all educational materials</p>
                </div>
            </div>
            <div class="col-md-4 mb-4">
                <div class="feature-card">
                    <div class="feature-icon">
                        <i class="fas fa-headset"></i>
                    </div>
                    <h3>Support 24/7</h3>
                    <p>Our customer service team is always ready to assist you with any inquiries</p>
                </div>
            </div>
        </div>
    </div>
</section>

<!-- Books Section -->
<section class="books">
    <div class="container">
        <div class="section-title">
            <h2>Featured Books</h2>
            <p>Explore our collection of bestselling educational resources</p>
        </div>
        <div class="row">
            <div class="col-lg-3 col-md-6 mb-4">
                <div class="book-card">
                    <div class="book-img">
                        <img src="https://images.unsplash.com/photo-1544947950-fa07a98d237f?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=600&q=80" alt="Book Cover">
                    </div>
                    <div class="book-info">
                        <h4 class="book-title">Advanced Mathematics</h4>
                        <p class="book-author">By Dr. Robert Smith</p>
                        <p class="book-price">$29.99</p>
                    </div>
                </div>
            </div>
            <div class="col-lg-3 col-md-6 mb-4">
                <div class="book-card">
                    <div class="book-img">
                        <img src="https://images.unsplash.com/photo-1532012197267-da84d127e765?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=600&q=80" alt="Book Cover">
                    </div>
                    <div class="book-info">
                        <h4 class="book-title">Literature Classics</h4>
                        <p class="book-author">By Emily Johnson</p>
                        <p class="book-price">$24.99</p>
                    </div>
                </div>
            </div>
            <div class="col-lg-3 col-md-6 mb-4">
                <div class="book-card">
                    <div class="book-img">
                        <img src="https://images.unsplash.com/photo-1627556704307-3134bf2b41ed?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=600&q=80" alt="Book Cover">
                    </div>
                    <div class="book-info">
                        <h4 class="book-title">Science Fundamentals</h4>
                        <p class="book-author">By Dr. Sarah Williams</p>
                        <p class="book-price">$32.99</p>
                    </div>
                </div>
            </div>
            <div class="col-lg-3 col-md-6 mb-4">
                <div class="book-card">
                    <div class="book-img">
                        <img src="https://images.unsplash.com/photo-1568667256549-094345857637?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=600&q=80" alt="Book Cover">
                    </div>
                    <div class="book-info">
                        <h4 class="book-title">History of Civilization</h4>
                        <p class="book-author">By Prof. James Anderson</p>
                        <p class="book-price">$27.99</p>
                    </div>
                </div>
            </div>
        </div>
        <div class="text-center mt-4">
            <a href="#" class="btn btn-primary">View All Books</a>
        </div>
    </div>
</section>

<!-- Testimonials Section -->
<section class="testimonials">
    <div class="container">
        <div class="section-title">
            <h2>What Our Customers Say</h2>
            <p>Read testimonials from our satisfied customers</p>
        </div>
        <div class="row">
            <div class="col-md-6">
                <div class="testimonial-card">
                    <p class="testimonial-text">The textbook selection at Pahana Edu is incredible. I found all the books I needed for my semester at great prices!</p>
                    <div class="testimonial-author">
                        <img src="https://randomuser.me/api/portraits/women/45.jpg" alt="Customer">
                        <div>
                            <h5 class="mb-0">Jessica Wilson</h5>
                            <small>University Student</small>
                        </div>
                    </div>
                </div>
            </div>
            <div class="col-md-6">
                <div class="testimonial-card">
                    <p class="testimonial-text">As a teacher, I regularly order books from Pahana Edu for my classroom. Their service is always prompt and reliable.</p>
                    <div class="testimonial-author">
                        <img src="https://randomuser.me/api/portraits/men/32.jpg" alt="Customer">
                        <div>
                            <h5 class="mb-0">Michael Thompson</h5>
                            <small>High School Teacher</small>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</section>

<!-- Footer -->
<footer class="footer">
    <div class="container">
        <div class="row">
            <div class="col-lg-4 mb-5 mb-lg-0">
                <h4 class="footer-title">Pahana Edu Bookshop</h4>
                <p>Providing quality educational resources since 2010. We're committed to supporting learning journeys with the best books and materials.</p>
                <div class="social-icons mt-4">
                    <a href="#"><i class="fab fa-facebook-f"></i></a>
                    <a href="#"><i class="fab fa-twitter"></i></a>
                    <a href="#"><i class="fab fa-instagram"></i></a>
                    <a href="#"><i class="fab fa-linkedin-in"></i></a>
                </div>
            </div>
            <div class="col-lg-2 col-md-4 mb-4 mb-md-0">
                <h4 class="footer-title">Quick Links</h4>
                <ul class="footer-links">
                    <li><a href="#">Home</a></li>
                    <li><a href="#">Books</a></li>
                    <li><a href="#">Categories</a></li>
                    <li><a href="#">About Us</a></li>
                    <li><a href="#">Contact</a></li>
                </ul>
            </div>
            <div class="col-lg-2 col-md-4 mb-4 mb-md-0">
                <h4 class="footer-title">Categories</h4>
                <ul class="footer-links">
                    <li><a href="#">Mathematics</a></li>
                    <li><a href="#">Science</a></li>
                    <li><a href="#">Literature</a></li>
                    <li><a href="#">History</a></li>
                    <li><a href="#">Reference</a></li>
                </ul>
            </div>
            <div class="col-lg-4 col-md-4">
                <h4 class="footer-title">Contact Info</h4>
                <ul class="footer-links">
                    <li><i class="fas fa-map-marker-alt me-2"></i> 123 Education Street, City</li>
                    <li><i class="fas fa-phone me-2"></i> (123) 456-7890</li>
                    <li><i class="fas fa-envelope me-2"></i> info@pahanaedu.com</li>
                    <li><i class="fas fa-clock me-2"></i> Mon-Fri: 9AM - 5PM</li>
                </ul>
            </div>
        </div>
        <div class="copyright">
            <p>&copy; 2023 Pahana Edu Bookshop. All Rights Reserved.</p>
        </div>
    </div>
</footer>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>