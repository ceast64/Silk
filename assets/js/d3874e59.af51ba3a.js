"use strict";(self.webpackChunkdocs=self.webpackChunkdocs||[]).push([[374],{3905:(e,t,r)=>{r.d(t,{Zo:()=>s,kt:()=>d});var n=r(67294);function a(e,t,r){return t in e?Object.defineProperty(e,t,{value:r,enumerable:!0,configurable:!0,writable:!0}):e[t]=r,e}function l(e,t){var r=Object.keys(e);if(Object.getOwnPropertySymbols){var n=Object.getOwnPropertySymbols(e);t&&(n=n.filter((function(t){return Object.getOwnPropertyDescriptor(e,t).enumerable}))),r.push.apply(r,n)}return r}function o(e){for(var t=1;t<arguments.length;t++){var r=null!=arguments[t]?arguments[t]:{};t%2?l(Object(r),!0).forEach((function(t){a(e,t,r[t])})):Object.getOwnPropertyDescriptors?Object.defineProperties(e,Object.getOwnPropertyDescriptors(r)):l(Object(r)).forEach((function(t){Object.defineProperty(e,t,Object.getOwnPropertyDescriptor(r,t))}))}return e}function i(e,t){if(null==e)return{};var r,n,a=function(e,t){if(null==e)return{};var r,n,a={},l=Object.keys(e);for(n=0;n<l.length;n++)r=l[n],t.indexOf(r)>=0||(a[r]=e[r]);return a}(e,t);if(Object.getOwnPropertySymbols){var l=Object.getOwnPropertySymbols(e);for(n=0;n<l.length;n++)r=l[n],t.indexOf(r)>=0||Object.prototype.propertyIsEnumerable.call(e,r)&&(a[r]=e[r])}return a}var c=n.createContext({}),u=function(e){var t=n.useContext(c),r=t;return e&&(r="function"==typeof e?e(t):o(o({},t),e)),r},s=function(e){var t=u(e.components);return n.createElement(c.Provider,{value:t},e.children)},m={inlineCode:"code",wrapper:function(e){var t=e.children;return n.createElement(n.Fragment,{},t)}},p=n.forwardRef((function(e,t){var r=e.components,a=e.mdxType,l=e.originalType,c=e.parentName,s=i(e,["components","mdxType","originalType","parentName"]),p=u(r),d=a,f=p["".concat(c,".").concat(d)]||p[d]||m[d]||l;return r?n.createElement(f,o(o({ref:t},s),{},{components:r})):n.createElement(f,o({ref:t},s))}));function d(e,t){var r=arguments,a=t&&t.mdxType;if("string"==typeof e||a){var l=r.length,o=new Array(l);o[0]=p;var i={};for(var c in t)hasOwnProperty.call(t,c)&&(i[c]=t[c]);i.originalType=e,i.mdxType="string"==typeof e?e:a,o[1]=i;for(var u=2;u<l;u++)o[u]=r[u];return n.createElement.apply(null,o)}return n.createElement.apply(null,r)}p.displayName="MDXCreateElement"},4167:(e,t,r)=>{r.r(t),r.d(t,{HomepageFeatures:()=>v,default:()=>N});var n=r(87462),a=r(67294),l=r(3905);const o={toc:[{value:"TODO (in no particular order):",id:"todo-in-no-particular-order",level:2}]};function i(e){let{components:t,...r}=e;return(0,l.kt)("wrapper",(0,n.Z)({},o,r,{components:t,mdxType:"MDXLayout"}),(0,l.kt)("h1",{id:"yarnspinnerrbx"},"YarnSpinnerRbx"),(0,l.kt)("h2",{id:"todo-in-no-particular-order"},"TODO (in no particular order):"),(0,l.kt)("ul",null,(0,l.kt)("li",{parentName:"ul"},(0,l.kt)("strong",{parentName:"li"},"WRITE A BETTER README")),(0,l.kt)("li",{parentName:"ul"},"lots of testing"),(0,l.kt)("li",{parentName:"ul"},"debug info callbacks"),(0,l.kt)("li",{parentName:"ul"},(0,l.kt)("del",{parentName:"li"},"move Dialogue.Library to its own class")),(0,l.kt)("li",{parentName:"ul"},(0,l.kt)("del",{parentName:"li"},"implement functions required for expressions (Number.Add, Number.EqualTo, etc.)")),(0,l.kt)("li",{parentName:"ul"},"implement default commands"),(0,l.kt)("li",{parentName:"ul"},"command parser"),(0,l.kt)("li",{parentName:"ul"},"refactor code, namely typedefs, to improve ease of use"),(0,l.kt)("li",{parentName:"ul"},"clean up API docs"),(0,l.kt)("li",{parentName:"ul"},"write beginner's guide and other docs"),(0,l.kt)("li",{parentName:"ul"},"test suite"),(0,l.kt)("li",{parentName:"ul"},"example projects with tutorials on docs site"),(0,l.kt)("li",{parentName:"ul"},"some way to debug dialogue (plugin/in game?)"),(0,l.kt)("li",{parentName:"ul"},"automate CLI build & release for tools like Aftman"),(0,l.kt)("li",{parentName:"ul"},"automate module build & release to Wally")),(0,l.kt)("p",null,"Ok, you have fun with all That!\nI have a life to live for god's sake!"))}i.isMDXComponent=!0;var c=r(39960),u=r(52263),s=r(4194),m=r(86010);const p="heroBanner_e1Bh",d="buttons_VwD3",f="features_WS6B",y="featureSvg_tqLR",b=[{title:"Feature 1",description:"This is a feature",image:"https://url"},{title:"Feature 2",description:"This is a second feature",image:"https://url"}];function g(e){let{image:t,title:r,description:n}=e;return a.createElement("div",{className:(0,m.Z)("col col--4")},t&&a.createElement("div",{className:"text--center"},a.createElement("img",{className:y,alt:r,src:t})),a.createElement("div",{className:"text--center padding-horiz--md"},a.createElement("h3",null,r),a.createElement("p",null,n)))}function v(){return b?a.createElement("section",{className:f},a.createElement("div",{className:"container"},a.createElement("div",{className:"row"},b.map(((e,t)=>a.createElement(g,(0,n.Z)({key:t},e))))))):null}function E(){const{siteConfig:e}=(0,u.Z)();return a.createElement("header",{className:(0,m.Z)("hero",p)},a.createElement("div",{className:"container"},a.createElement("h1",{className:"hero__title"},e.title),a.createElement("p",{className:"hero__subtitle"},e.tagline),a.createElement("div",{className:d},a.createElement(c.Z,{className:"button button--secondary button--lg",to:"/docs/intro"},"Get Started \u2192"))))}function N(){const{siteConfig:e,tagline:t}=(0,u.Z)();return a.createElement(s.Z,{title:e.title,description:t},a.createElement(E,null),a.createElement("main",null,a.createElement(v,null),a.createElement("div",{className:"container"},a.createElement(i,null))))}}}]);