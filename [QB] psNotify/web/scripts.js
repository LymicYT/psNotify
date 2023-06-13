let containerElement;
let containerElementTopOffset = 0;

function addNotification(title, message, time, notificationType, playSound) {
    containerElement = document.getElementById('container');
    containerElementTopOffset = containerElement.getBoundingClientRect().top;

    let notificationElement = document.createElement('div');
    notificationElement.className = 'notification ' + notificationType;

    let lineElement = document.createElement('div');
    lineElement.className = 'line';
    notificationElement.appendChild(lineElement);

    let contentElement = document.createElement('div');
    contentElement.className = 'content';
    notificationElement.appendChild(contentElement);

    let titleElement = document.createElement('div');
    titleElement.className = 'title';
    titleElement.innerHTML = title;
    contentElement.appendChild(titleElement);

    let messageElement = document.createElement('div');
    messageElement.className = 'message';
    messageElement.innerHTML = message;
    contentElement.appendChild(messageElement);

    containerElement.appendChild(notificationElement);

    anime({
        targets: notificationElement,
        translateX: [(true ? -1 : 1) * notificationElement.offsetWidth, 0],
        easing: 'spring(1, 70, 100, 10)',
        duration: 1000,
        endDelay: time / 2,
        direction: 'alternate',
        complete: function () {
            notificationElement.remove();
        }
    });

    if (playSound) {
        const sound = new Audio('notify.mp3');
        sound.volume = 0.8;
        sound.play().catch(error => {
            console.error('Failed to play notification sound:', error);
        });
    }
}

window.addEventListener('message', function(event) {
    if (event.data.type === 'notification') {
        addNotification(event.data.title, event.data.message, event.data.time, event.data.notificationType, event.data.playSound);
    }
});
