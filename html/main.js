var tasks = [];

window.addEventListener('message', function(event) {
    let item = event.data;
    if(item.status===true) {
        display(true);
    } else if(item.status===false) {
        display(false);
    };
    if(item.t==='r') {
        for(let i=0;i<item.d.length;i++) {
            document.getElementById('rot'+item.d[i].r).textContent = item.d[i].v.toFixed(10);
        };
    };
    if(item.c==='c') {
        for(let i=0;i<item.d.length;i++) {
            document.getElementById('cor'+item.d[i].r).textContent = item.d[i].v.toFixed(10);
        };
    };
    if(item.t==='c') {
        let data = ['rotx', 'roty', 'rotz', 'corx', 'cory', 'corz'];
        let retval;
        if(tasks.length===0) {
            retval = '{ccm:'
        } else {
            retval = 'cmp:'
        };
        for(let i=0;i<data.length;i++) {
            if((i+1)==data.length) {
                let left = (document.getElementById('arrow').style.rotate === '180deg' || document.getElementById('arrow').style.rotate=='');
                retval = retval + document.getElementById(data[i]).textContent + ',' + (left&&'1'||'0')+','+document.getElementById('ms').textContent+';';
            } else {
                retval = retval + document.getElementById(data[i]).textContent + ',';
            };
        };
        tasks[tasks.length] = retval;
        document.getElementById('span').textContent = tasks.length;
        $('#after').append(`<div class id="${tasks.length-1}">${retval}</div>`)
    };
    if(item.t==='d') {
        tasks.splice(tasks.length-1,1);
        document.getElementById('span').textContent = tasks.length;
        document.getElementById(tasks.length).remove();
    };
    if(item.t==='s') {
        if(item.r===1) {
            document.getElementById('after').style.opacity = '1.0';
        } else {
            document.getElementById('after').style.opacity = '0';
        };
    };
    if(item.t==='e') {
        let task = "";
        for(let i=0; i<tasks.length; i++) {
            task = task + document.getElementById(i).textContent;
        };
        task = task + '}';
        task = task.replace(';}', '}');
        CopyToClipboard(task);
    };
    if(item.t==='x') {
        if(item.d==='a') {
            document.getElementById('arrow').style.rotate = '180deg';
        } else {
            document.getElementById('arrow').style.rotate = '0deg';
        };
    };
    if(item.t=='u') {
        let doc = document.getElementById('ms');
        doc.textContent = Number(doc.textContent)+10;
    } else if(item.t=='i') {
        let doc = document.getElementById('ms');
        doc.textContent = Number(doc.textContent)-10;
    };
    if(item.s=='s') {
        document.getElementById('speed').textContent = item.d;
    };
});

function display(status) {
    if(status===true) {
        $('body').show();
    } else {
        $('body').hide();
    }
};

function CopyToClipboard(text) {
    var copy = $('<textarea/>');
    copy.text(text);
    $('body').append(copy);
    copy.select();
    document.execCommand('copy');
    copy.remove();
};

display(false);