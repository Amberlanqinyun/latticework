# Generates mockups.html — Notion-premium, Open Sans only, bespoke icon set.

I = {
 # tab + title glyphs
 'today':'<path d="M3.5 18h17"/><path d="M7.2 18a4.8 4.8 0 0 1 9.6 0"/><path d="M12 4.2v2.4M5.3 9.1l1.6 1.5M18.7 9.1l-1.6 1.5"/>',
 'library':'<path d="M12 3.2 3.6 7 12 10.8 20.4 7 12 3.2Z"/><path d="m3.6 12.1 8.4 3.8 8.4-3.8"/><path d="m3.6 16.7 8.4 3.8 8.4-3.8"/>',
 'drills':'<circle cx="12" cy="12" r="8.2"/><circle cx="12" cy="12" r="4.4"/><circle cx="12" cy="12" r=".9"/>',
 'journal':'<path d="M6.4 3.6H19v16.8H6.4A1.4 1.4 0 0 1 5 19V5a1.4 1.4 0 0 1 1.4-1.4Z"/><path d="M5 17.4h14"/><path d="M9 3.6V17"/>',
 'profile':'<circle cx="12" cy="8.4" r="3.4"/><path d="M5.9 19.6a6.1 6.1 0 0 1 12.2 0"/>',
 'lattice':'<circle cx="6" cy="6" r="1.5"/><circle cx="18" cy="6" r="1.5"/><circle cx="6" cy="18" r="1.5"/><circle cx="18" cy="18" r="1.5"/><circle cx="12" cy="12" r="1.6"/><path d="m7.5 7.5 3 3M16.5 7.5l-3 3M7.5 16.5l3-3M16.5 16.5l-3-3"/>',
 # discipline / concept marks
 'psychology':'<path d="M12 20.5a8.5 8.5 0 1 1 6-2.5"/><path d="M12 15.5a3.5 3.5 0 1 1 2.5-1"/><circle cx="12" cy="12" r=".8"/>',
 'economics':'<path d="M4 16.5 9.2 11l2.8 2.8L20 6"/><path d="M15.5 6H20v4.5"/>',
 'math':'<circle cx="9.3" cy="12" r="5.4"/><circle cx="14.7" cy="12" r="5.4"/>',
 'inversion':'<path d="M7 8h9.5l-3-3"/><path d="M17 16H7.5l3 3"/>',
 'shield':'<path d="M12 3.4 5.4 6v5.2c0 4 2.8 6.9 6.6 8.4 3.8-1.5 6.6-4.4 6.6-8.4V6L12 3.4Z"/>',
 'people':'<circle cx="9" cy="9.2" r="3"/><path d="M3.6 19a5.4 5.4 0 0 1 10.8 0"/><path d="M15.5 6.6a3 3 0 0 1 0 5.7M20.4 19a5.4 5.4 0 0 0-3.9-5.2"/>',
 'circle':'<circle cx="12" cy="12" r="8.3"/><circle cx="12" cy="12" r="3.4"/>',
 'eye':'<path d="M2.6 12S6 5.7 12 5.7 21.4 12 21.4 12 18 18.3 12 18.3 2.6 12 2.6 12Z"/><circle cx="12" cy="12" r="2.5"/>',
 # stats + misc
 'flame':'<path d="M12 3.5c.6 3.2-1.4 4.4-1.4 6.5a2.7 2.7 0 0 0 5.4 0c0-.9-.3-1.7-.8-2.4 2.3 1.2 3.8 3.6 3.8 6.3a7 7 0 0 1-14 0c0-3.4 2.4-5.2 3.6-7.1.5 1.4 1.5 2.3 2.6 2.4C12.3 8.6 12 6 12 3.5Z"/>',
 'seal':'<circle cx="12" cy="12" r="8.4"/><path d="m8.4 12 2.6 2.6 4.6-5.2"/>',
 'search':'<circle cx="11" cy="11" r="6.6"/><path d="m20 20-3.8-3.8"/>',
 'pencil':'<path d="M14.5 5.5 18.5 9.5M4 20l1-4L16 5a2 2 0 0 1 3 3L8 19l-4 1Z"/>',
 'back':'<path d="M14.5 6 9 12l5.5 6"/>',
 'x':'<path d="M6.5 6.5l11 11M17.5 6.5l-11 11"/>',
 'spark':'<path d="M12 3.5v4M12 16.5v4M3.5 12h4M16.5 12h4"/><circle cx="12" cy="12" r="2.4"/>',
}

def svg(name, cls='ic', size=None):
    st = f' style="width:{size}px;height:{size}px"' if size else ''
    return f'<svg class="{cls}"{st} viewBox="0 0 24 24">{I[name]}</svg>'

def chip(name):  # title glyph chip
    return f'<span class="glyph">{svg(name,"gic")}</span>'

def disc(name):  # list/discipline glyph
    return f'<span class="disc">{svg(name,"dic")}</span>'

def pic(name):   # tiny pill icon
    return f'{svg(name,"pic")}'

def tabs(active):
    items=[('today','Today'),('library','Library'),('drills','Drills'),('journal','Journal'),('profile','Profile')]
    out='<div class="tabs">'
    for key,lbl in items:
        on=' on' if key==active else ''
        out+=f'<div class="tab{on}">{svg(key)}<span>{lbl}</span></div>'
    return out+'</div>'

def screen(active, inner):
    return (f'<div class="phone"><div class="notch"></div><div class="screen">'
            f'<div class="status"><span>9:41</span><span class="right">{svg("spark","sic")} 100</span></div>'
            f'<div class="body">{inner}</div>{tabs(active)}</div></div>')

def label(num,title,sub):
    return f'<div class="label"><div class="num">{num}</div><b>{title}</b><span>{sub}</span></div>'

# ---------- screens ----------
today = screen('today', f'''
  <div class="ttl">{chip('today')}<span>Today</span></div>
  <div class="block tint"><div class="row" style="gap:16px">
    <div class="ring"><i>12</i></div>
    <div><b style="font-size:15px;font-weight:600">12-day streak</b>
      <div class="small muted" style="margin-top:3px">Keep the latticework growing</div></div>
  </div></div>
  <div class="block">
    <div class="kicker">{pic('inversion')}<span>Inversion · model of the day</span></div>
    <div class="display" style="margin:14px 0 16px">Inversion</div>
    <div class="quote">&ldquo;All I want to know is where I&rsquo;m going to die, so I&rsquo;ll never go there.&rdquo;</div>
    <div class="attr">Charlie Munger</div>
  </div>
  <div class="block">
    <b style="font-size:14.5px;font-weight:600">Apply it today</b>
    <div class="small muted" style="margin-top:8px;line-height:1.6">When a goal feels overwhelming, flip it &mdash; what would guarantee the worst outcome?</div>
    <div class="btn">Mark complete</div>
  </div>''')

library = screen('library', f'''
  <div class="ttl">{chip('library')}<span>Library</span></div>
  <div class="block search">{svg('search','dic')}<span>Search models &amp; quotes</span></div>
  <div class="sec">{pic('psychology')}<span>Psychology</span></div>
  <div class="block listrow">
    <div class="listitem">{disc('eye')}<div><b>Incentive-Caused Bias</b><div class="xs muted">Psychology</div></div></div>
    <div class="listitem">{disc('people')}<div><b>Social Proof</b><div class="xs muted">Psychology</div></div></div>
    <div class="listitem">{disc('psychology')}<div><b>Confirmation Bias</b><div class="xs muted">Psychology</div></div></div>
  </div>
  <div class="sec">{pic('economics')}<span>Economics</span></div>
  <div class="block listrow">
    <div class="listitem">{disc('circle')}<div><b>Circle of Competence</b><div class="xs muted">Economics</div></div></div>
  </div>
  <div class="sec">{pic('math')}<span>Math &amp; Probability</span></div>
  <div class="block listrow">
    <div class="listitem">{disc('math')}<div><b>Compounding</b><div class="xs muted">Math &amp; Probability</div></div></div>
  </div>''')

detail = screen('library', f'''
  <div class="crumb">{svg('back','dic')}<span>Library</span></div>
  <div class="display" style="font-size:26px;margin:6px 0 12px">Incentive-Caused Bias</div>
  <div class="row" style="gap:8px;margin-bottom:20px">
    <span class="pill">{pic('psychology')}Psychology</span>
    <span class="pill">{pic('drills')}Learning</span></div>
  <div class="quote" style="font-size:19px">&ldquo;Show me the incentive and I will show you the outcome.&rdquo;</div>
  <div class="attr">Charlie Munger</div>
  <div class="kv">What it is</div>
  <div class="kp">People unconsciously rationalize behavior that serves their incentives. To predict behavior, study the incentives &mdash; not the stated intentions.</div>
  <div class="kv">The trap it prevents</div>
  <div class="kp">Trusting stated motives while ignoring the rewards shaping them.</div>
  <div class="btn">{svg('drills','bic')}<span>Start drill</span></div>''')

drill = screen('drills', f'''
  <div class="row sheettop"><span class="muted small">Close</span>
    <b class="small" style="font-weight:600">Incentive-Caused Bias</b><span style="width:34px"></span></div>
  <div class="display" style="font-size:21px;line-height:1.4;margin-bottom:20px">A fund manager insists their high-fee product is best for you. What should you weigh most?</div>
  <div class="opt">Their confidence</div>
  <div class="opt wrong">Their credentials {svg('x','optic')}</div>
  <div class="opt right">How they are compensated {svg('seal','optic')}</div>
  <div class="opt">How long they&rsquo;ve worked there</div>
  <div class="block tint" style="margin-top:18px">
    <div class="kv" style="margin-top:0">Why</div>
    <div class="kp" style="margin-bottom:0">Incentive-caused bias predicts that compensation structure shapes the recommendation more than sincerity does.</div>
  </div>
  <div class="btn">Done</div>''')

journal = screen('journal', f'''
  <div class="ttl" style="justify-content:space-between">
    <span style="display:flex;align-items:center;gap:12px">{chip('journal')}<span>Journal</span></span>
    <span class="iconbtn">{svg('pencil','dic')}</span></div>
  <div class="block">
    <b style="font-size:14.5px;font-weight:600">Hire the senior engineer?</b>
    <div class="metaline">Jun 11 · 70% confident · <span class="ok">{svg('seal','metic')}Reviewed</span></div>
    <div class="row" style="gap:7px;margin-top:13px;flex-wrap:wrap">
      <span class="pill">{pic('inversion')}Inversion</span>
      <span class="pill">{pic('circle')}Circle of Competence</span></div>
  </div>
  <div class="block">
    <b style="font-size:14.5px;font-weight:600">Hold or sell the position?</b>
    <div class="metaline">Jun 9 · 55% confident</div>
    <div class="row" style="gap:7px;margin-top:13px;flex-wrap:wrap">
      <span class="pill">{pic('shield')}Margin of Safety</span>
      <span class="pill">{pic('people')}Social Proof</span></div>
  </div>
  <div class="block">
    <b style="font-size:14.5px;font-weight:600">Sign the office lease?</b>
    <div class="metaline">Jun 4 · 80% confident · <span class="ok">{svg('seal','metic')}Reviewed</span></div>
  </div>''')

profile = screen('profile', f'''
  <div class="ttl">{chip('profile')}<span>Profile</span></div>
  <div class="block listrow stats">
    <div class="listitem"><span class="statL">{disc('flame')}Current streak</span><b class="statV">12 days</b></div>
    <div class="listitem"><span class="statL">{disc('journal')}Models learning</span><b class="statV">7</b></div>
    <div class="listitem"><span class="statL">{disc('seal')}Models mastered</span><b class="statV">4 / 31</b></div>
  </div>
  <div class="sec plain"><span>Subscription</span></div>
  <div class="block premium">
    <div class="display" style="font-size:19px">Latticework Premium</div>
    <div class="small muted" style="margin-top:8px;line-height:1.55">Full library, advanced drills, and iCloud sync across your devices.</div>
    <div class="btn">Upgrade · $49.99/yr</div>
    <div class="btn ghost">Restore purchase</div>
  </div>
  <div class="sec plain"><span>About</span></div>
  <div class="block tint"><div class="xs muted" style="line-height:1.6">Built on the worldly wisdom of Charlie Munger. Quotes are short, attributed excerpts used for educational commentary.</div></div>''')

grid = ''.join([
  f'<div>{today}{label("01","Today","Daily model · streak · apply")}</div>',
  f'<div>{library}{label("02","Library","Models by discipline · search")}</div>',
  f'<div>{detail}{label("03","Model Detail","Quote · definition · drill")}</div>',
  f'<div>{drill}{label("04","Drill","Recall · instant feedback")}</div>',
  f'<div>{journal}{label("05","Decision Journal","The retention feature")}</div>',
  f'<div>{profile}{label("06","Profile","Stats · subscription")}</div>',
])

html = f'''<!DOCTYPE html>
<html lang="en"><head><meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Latticework — Mockups</title>
<link rel="preconnect" href="https://fonts.googleapis.com">
<link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
<link href="https://fonts.googleapis.com/css2?family=Open+Sans:ital,wght@0,300;0,400;0,500;0,600;0,700;1,300;1,400;1,600&display=swap" rel="stylesheet">
<style>
  :root{{
    --bg:#FFFFFF; --page:#F7F6F3; --ink:#37352F; --ink2:#787774; --faint:#9B9A97;
    --line:rgba(55,53,47,.09); --line2:rgba(55,53,47,.15); --hover:rgba(55,53,47,.04);
    --green:#448361; --red:#C4554D; --tag:#F1F0EE;
    --f:"Open Sans",-apple-system,BlinkMacSystemFont,"Segoe UI",sans-serif;
  }}
  *{{margin:0;padding:0;box-sizing:border-box;-webkit-font-smoothing:antialiased;text-rendering:optimizeLegibility;}}
  body{{font-family:var(--f);background:var(--page);color:var(--ink);padding:96px 64px 120px;letter-spacing:-.002em;}}
  svg{{stroke:currentColor;fill:none;stroke-width:1.55;stroke-linecap:round;stroke-linejoin:round;}}

  /* header */
  .head{{max-width:1480px;margin:0 auto 96px;}}
  .head .eyebrow{{font-size:13px;font-weight:600;color:var(--ink2);margin-bottom:28px;display:flex;align-items:center;gap:11px;letter-spacing:.01em;}}
  .head .eyebrow .mark{{width:30px;height:30px;border:1px solid var(--line2);border-radius:9px;display:inline-flex;align-items:center;justify-content:center;}}
  .head .eyebrow .mark svg{{width:17px;height:17px;}}
  .head h1{{font-size:clamp(44px,5.2vw,72px);font-weight:300;letter-spacing:-.035em;line-height:1.05;max-width:900px;}}
  .head h1 b{{font-weight:600;}}
  .head p{{color:var(--ink2);margin-top:26px;font-size:17px;max-width:540px;line-height:1.65;font-weight:400;}}
  .head .rule{{height:1px;background:var(--line);margin-top:48px;}}

  .grid{{max-width:1480px;margin:0 auto;display:grid;grid-template-columns:repeat(3,1fr);gap:104px 64px;justify-items:center;}}
  .label{{margin-top:30px;width:348px;}}
  .label .num{{font-size:12px;font-weight:600;color:var(--faint);font-variant-numeric:tabular-nums;letter-spacing:.04em;}}
  .label b{{font-size:20px;font-weight:600;display:block;margin-top:5px;letter-spacing:-.015em;}}
  .label span{{font-size:13.5px;color:var(--ink2);}}

  /* device */
  .phone{{width:348px;height:752px;border-radius:55px;
    background:linear-gradient(160deg,#45453f,#1d1d1a 40%,#161613 72%,#34342f);
    padding:11px;position:relative;box-shadow:0 1px 1px rgba(15,15,15,.04),0 40px 70px -34px rgba(15,15,15,.3);}}
  .screen{{width:100%;height:100%;border-radius:45px;overflow:hidden;background:var(--bg);position:relative;display:flex;flex-direction:column;}}
  .notch{{position:absolute;top:13px;left:50%;transform:translateX(-50%);width:104px;height:30px;background:#0a0a09;border-radius:18px;z-index:30;}}
  .status{{display:flex;justify-content:space-between;align-items:center;padding:18px 30px 4px;font-size:14px;font-weight:600;z-index:20;}}
  .status .right{{display:flex;align-items:center;gap:6px;font-size:13px;}}
  .sic{{width:14px;height:14px;}}

  .body{{flex:1;overflow:hidden;padding:10px 24px 0;}}

  /* type system, Open Sans only — premium via weight + space */
  .ttl{{display:flex;align-items:center;gap:13px;font-size:27px;font-weight:700;letter-spacing:-.03em;margin:12px 0 24px;}}
  .display{{font-size:30px;font-weight:300;letter-spacing:-.03em;line-height:1.1;}}
  .quote{{font-style:italic;font-weight:300;font-size:17px;color:var(--ink);line-height:1.55;letter-spacing:-.01em;}}
  .attr{{font-size:12px;color:var(--faint);margin-top:14px;font-weight:600;letter-spacing:.02em;}}
  .kicker{{display:flex;align-items:center;gap:8px;font-size:11px;font-weight:600;color:var(--faint);letter-spacing:.04em;text-transform:uppercase;}}
  .kicker .pic{{width:14px;height:14px;color:var(--ink2);}}
  .kv{{font-size:11px;font-weight:700;color:var(--faint);letter-spacing:.07em;text-transform:uppercase;margin:22px 0 8px;}}
  .kp{{font-size:13.5px;line-height:1.62;color:#4b4943;margin-bottom:4px;}}
  .crumb{{display:flex;align-items:center;gap:5px;color:var(--ink2);font-weight:600;font-size:14px;margin:6px 0 10px;}}
  .crumb .dic{{width:17px;height:17px;}}
  .muted{{color:var(--ink2);}} .small{{font-size:13px;}} .xs{{font-size:11.5px;}}
  .row{{display:flex;align-items:center;}}

  /* blocks — airy, hairline, flat */
  .block{{background:var(--bg);border:1px solid var(--line);border-radius:12px;padding:22px;}}
  .block+.block{{margin-top:16px;}}
  .block.tint{{background:#FBFBFA;}}
  .block.search{{display:flex;align-items:center;gap:10px;color:var(--faint);font-size:14px;padding:15px 18px;}}
  .block.search .dic{{width:17px;height:17px;}}
  .listrow{{padding:6px 14px;}}
  .listitem{{display:flex;align-items:center;gap:13px;padding:13px 6px;border-radius:8px;}}
  .listrow .listitem+.listitem{{border-top:1px solid var(--line);}}
  .listitem b{{font-weight:600;font-size:14.5px;}}

  .glyph{{width:34px;height:34px;border:1px solid var(--line2);border-radius:10px;display:inline-flex;align-items:center;justify-content:center;color:var(--ink);}}
  .gic{{width:19px;height:19px;}}
  .disc{{width:30px;height:30px;border-radius:8px;background:var(--tag);display:inline-flex;align-items:center;justify-content:center;color:var(--ink);flex:none;}}
  .dic{{width:17px;height:17px;}}
  .pic{{width:13px;height:13px;flex:none;}}

  .ring{{width:50px;height:50px;border-radius:50%;background:conic-gradient(var(--ink) 0 252deg,#E8E7E3 252deg 360deg);display:flex;align-items:center;justify-content:center;flex:none;}}
  .ring i{{width:40px;height:40px;border-radius:50%;background:var(--bg);display:flex;align-items:center;justify-content:center;font-style:normal;font-weight:600;font-size:14px;}}

  .tabs{{height:84px;border-top:1px solid var(--line);background:rgba(255,255,255,.92);backdrop-filter:blur(20px);display:flex;justify-content:space-around;align-items:flex-start;padding-top:14px;}}
  .tab{{display:flex;flex-direction:column;align-items:center;gap:7px;font-size:10px;color:var(--faint);font-weight:600;letter-spacing:.01em;}}
  .tab.on{{color:var(--ink);}}
  .ic{{width:22px;height:22px;}}

  .btn{{display:flex;align-items:center;justify-content:center;gap:8px;background:var(--ink);color:#fff;border-radius:9px;padding:14px;text-align:center;font-weight:600;font-size:14.5px;margin-top:20px;letter-spacing:.01em;}}
  .btn .bic{{width:17px;height:17px;}}
  .btn.ghost{{background:transparent;color:var(--ink2);border:1px solid var(--line2);margin-top:10px;}}

  .pill{{display:inline-flex;align-items:center;gap:6px;background:var(--tag);color:var(--ink2);border-radius:6px;padding:5px 10px;font-size:12px;font-weight:600;}}
  .pill .pic{{color:var(--ink2);}}
  .metaline{{font-size:11.5px;color:var(--ink2);margin-top:7px;display:flex;align-items:center;gap:6px;}}
  .ok{{color:var(--green);display:inline-flex;align-items:center;gap:4px;}}
  .metic{{width:13px;height:13px;}}
  .iconbtn{{width:32px;height:32px;border-radius:8px;display:inline-flex;align-items:center;justify-content:center;color:var(--ink2);}}
  .iconbtn .dic{{width:18px;height:18px;}}

  .stats .statL{{display:flex;align-items:center;gap:11px;font-size:14px;}}
  .stats .statV{{margin-left:auto;font-weight:600;font-variant-numeric:tabular-nums;}}
  .premium{{border:1px solid var(--line2);}}

  .opt{{display:flex;justify-content:space-between;align-items:center;border:1px solid var(--line2);border-radius:9px;padding:14px 15px;font-size:14px;margin-top:11px;}}
  .opt.right{{border-color:var(--green);background:#F2F7F4;}}
  .opt.wrong{{border-color:var(--red);background:#FBF3F2;}}
  .opt .optic{{width:16px;height:16px;}}
  .opt.right .optic{{color:var(--green);}} .opt.wrong .optic{{color:var(--red);transform:rotate(0);}}
  .sec{{display:flex;align-items:center;gap:8px;font-size:11px;font-weight:700;color:var(--faint);letter-spacing:.07em;text-transform:uppercase;margin:26px 6px 10px;}}
  .sec .pic{{width:14px;height:14px;}}
  .sec.plain{{margin-top:24px;}}
  .sheettop{{justify-content:space-between;margin:6px 0 22px;}}
</style></head>
<body>
<div class="head">
  <div class="eyebrow"><span class="mark">{svg('lattice','mic')}</span> Mental models · iOS concept</div>
  <h1>A calmer way to think,<br><b>one model a day.</b></h1>
  <p>Latticework turns Charlie Munger&rsquo;s worldly wisdom into a daily practice. Clean surfaces, a single typeface, and a bespoke mark for every idea.</p>
  <div class="rule"></div>
</div>
<div class="grid">{grid}</div>
</body></html>'''

open('mockups.html','w').write(html)
print("wrote mockups.html", len(html), "bytes")
