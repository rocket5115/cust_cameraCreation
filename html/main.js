var tasks = [];
var anims = [];
var anim = 0;

var timeline = [];
var chosen = 0;
var lastchosen = 0;

var menu = false;

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
    if(item.t==='c'&&!menu) {
        let data = ['rotx', 'roty', 'rotz', 'corx', 'cory', 'corz'];
        let retval;
        if(tasks.length===0) {
            retval = '{ccm:'
        } else {
            retval = 'cmp:'
        };
        timeline[timeline.length] = [];
        for(let i=0;i<data.length;i++) {
            let doc = document.getElementById(data[i]);
            timeline[timeline.length-1][timeline[timeline.length-1].length] = doc.textContent;
            if((i+1)==data.length) {
                let left = (document.getElementById('arrow').style.rotate === '180deg' || document.getElementById('arrow').style.rotate=='');
                retval = retval + doc.textContent + ',' + (left&&'1'||'0')+','+document.getElementById('ms').textContent+','+(anim+1)+';';
            } else {
                retval = retval + doc.textContent + ',';
            };
        };
        timeline[timeline.length-1][timeline[timeline.length-1].length] = (document.getElementById('arrow').style.rotate === '180deg' || document.getElementById('arrow').style.rotate=='');
        timeline[timeline.length-1][timeline[timeline.length-1].length] = document.getElementById('ms').textContent;
        timeline[timeline.length-1][timeline[timeline.length-1].length] = (anim+1);
        updateTimeline();
        tasks[tasks.length] = retval;
        document.getElementById('span').textContent = tasks.length;
        $('#after').append(`<div class id="${tasks.length-1}">${retval}</div>`)
    } else if(item.t==='c'&&menu) {
        var d=[];
        if(tasks[chosen]&&tasks[chosen-1]) {
            d[0] = tasks[chosen-1];
            d[1] = tasks[chosen];
            $.post(`https://${GetParentResourceName()}/execute`, JSON.stringify({
                data: d
            }));
        } else {
            let doc = document.getElementById('exp');
            let save = doc.textContent;
            doc.textContent = 'You cannot choose first!';
            setTimeout(() => {
                if(menu) {
                    doc.textContent = save;
                } else {
                    doc.textContent = '';
                }
            }, 2000);
        };
    };
    if(item.t==='d') {
        tasks.splice(tasks.length-1,1);
        timeline.splice(timeline.length-1,1);
        document.getElementById('span').textContent = tasks.length;
        document.getElementById(tasks.length).remove();
        document.getElementById('time-'+timeline.length).remove();
    };
    if(item.t==='d2') {
        removeTimeline();
    };
    if(item.t==='s') {
        if(item.r===1) {
            document.getElementById('direct').style.opacity = '1.0';
            document.getElementById('mode').style.opacity = '1.0';
            document.getElementById('timeline').style.opacity = '1.0';
        } else {
            document.getElementById('direct').style.opacity = '0';
            document.getElementById('mode').style.opacity = '0';
            document.getElementById('timeline').style.opacity = '0';
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
    if(item.i=='i') {
        anims = item.d;
        document.getElementById('effect').innerHTML = (anim+1) + '/' + anims.length + '<br>'+anims[anim];
    };
    if(item.i=='u') {
        anim = item.d-1;
        document.getElementById('effect').innerHTML = (anim+1) + '/' + anims.length + '<br>'+anims[anim];
    };
    if(item.x=='x') {
        anim = item.d-1;
        document.getElementById('effect').innerHTML = (anim+1) + '/' + anims.length + '<br>'+anims[anim];
    };
    if(item.u=='u') {
        chosen++;
        if(timeline[chosen]) {
            document.getElementById('time-'+chosen).style.backgroundColor = 'rgb(125, 2, 2, 0.834)';
            document.getElementById('time-'+lastchosen).style.backgroundColor = 'rgba(58, 1, 1, 0.834)';
            lastchosen = chosen;
        } else {
            chosen = 0;
            document.getElementById('time-'+chosen).style.backgroundColor = 'rgb(125, 2, 2, 0.834)';
            document.getElementById('time-'+lastchosen).style.backgroundColor = 'rgba(58, 1, 1, 0.834)';
            lastchosen = chosen;
        }
    };
    if(item.u=='d') {
        chosen--;
        if(timeline[chosen]) {
            document.getElementById('time-'+chosen).style.backgroundColor = 'rgb(125, 2, 2, 0.834)';
            document.getElementById('time-'+lastchosen).style.backgroundColor = 'rgba(58, 1, 1, 0.834)';
            lastchosen = chosen;
        } else {
            chosen = timeline.length-1;
            document.getElementById('time-'+chosen).style.backgroundColor = 'rgb(125, 2, 2, 0.834)';
            document.getElementById('time-'+lastchosen).style.backgroundColor = 'rgba(58, 1, 1, 0.834)';
            lastchosen = chosen;
        }
    };
    if(item.h) {
        menu = true;
        document.getElementById('exp').textContent = 'Play Camera Sequence Activated';
    } else if(!item.h&&item.h!=null&&item.h!=undefined) {
        menu = false;
        document.getElementById('exp').textContent = '';
    };
    if(item.exp=='show') {
        let doc = document.getElementById('exp');
        let save = doc.textContent;
        doc.textContent = item.data;
        setTimeout(() => {
            if(menu) {
                doc.textContent = save;
            } else {
                doc.textContent = '';
            }
        }, item.time||2000);
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

function updateTimeline() {
    let len = timeline.length-1
    let left = (document.getElementById('arrow').style.rotate === '180deg' || document.getElementById('arrow').style.rotate=='');
    if(len==0) {
        $('#timeline').append(`<div class="timeline-data" id="time-${timeline.length-1}">${timeline.length} Rotation X:${timeline[0][0]}</br>Y:${timeline[0][1]}</br>Z:${timeline[0][2]}</br>Coords X:${timeline[0][3]}</br>Y:${timeline[0][4]}</br>Z:${timeline[0][5]}</br>Anim:${timeline[0][8]}</div>`)
    } else {
        $('#timeline').append(`<div class="timeline-data" id="time-${timeline.length-1}">${timeline.length} Rotation X:${timeline[len][0]}</br>Y:${timeline[len][1]}</br>Z:${timeline[len][2]}</br>Coords X:${timeline[len][3]}</br>Y:${timeline[len][4]}</br>Z:${timeline[len][5]}</br>Rot Order:${(left&&'left'||'right')}</br>Time:${timeline[len][7]}</br>Anim:${timeline[len][8]}</div>`)
    }
};

let first = false;

function removeTimeline() {
    if(chosen==(timeline.length-1)&&chosen!=0) {
        timeline.splice(timeline.length-1, 1);
        tasks.splice(tasks.length-1, 1);
        document.getElementById('time-'+timeline.length).remove();
        document.getElementById('span').textContent = tasks.length;
        chosen--;
        lastchosen--;
    } else if(chosen!=(timeline.length-1)&&chosen!=0) {
        timeline.splice(chosen, 1);
        tasks.splice(chosen, 1);
        let docs = document.querySelectorAll('.timeline-data');
        docs.forEach(doc => {
            doc.remove();
        });
        for(var i=0;i<timeline.length;i++) {
            let len = timeline.length-1
            if(len==0) {
                $('#timeline').append(`<div class="timeline-data" id="time-${i}">${i} Rotation X:${timeline[i][0]}</br>Y:${timeline[i][1]}</br>Z:${timeline[i][2]}</br>Coords X:${timeline[i][3]}</br>Y:${timeline[i][4]}</br>Z:${timeline[i][5]}</div>`)
            } else {
                $('#timeline').append(`<div class="timeline-data" id="time-${i}">${i} Rotation X:${timeline[i][0]}</br>Y:${timeline[i][1]}</br>Z:${timeline[i][2]}</br>Coords X:${timeline[i][3]}</br>Y:${timeline[i][4]}</br>Z:${timeline[i][5]}</br>Rot Order:${(timeline[i][6]&&'left'||'right')}</br>Time:${timeline[i][7]}</br>Anim:${timeline[i][8]}</div>`)
            }
        };
        document.getElementById('span').textContent = tasks.length;
        chosen--;
        lastchosen--;
    } else if(chosen==0) {
        if(timeline.length==1) {
            document.getElementById('time-'+0).remove();
            timeline.splice(0, 1);
            tasks.splice(0, 1);
            document.getElementById('span').textContent = tasks.length;
        } else {
            let doc = document.getElementById('mode');
            let save = doc.innerHTML;
            doc.style.color = 'red';
            doc.innerHTML = 'You cannot delete start of this scenario';
            setTimeout(() => {
                doc.style.color = 'black';
                doc.innerHTML = save;
            }, 2000);
        };
    };
};

display(false);
