

//Assignment 1 #change added title
const routes = {
    '/login': { templateId: 'login' ,title:'Login Page'},
    '/dashboard': { templateId: 'dashboard',title:'Dashboard'},
    '/credits': { templateId: 'credits',title:'Credits' },
  };



function updateRoute() {
  const path = window.location.pathname;
  const route = routes[path];
  
  if (!route) {
    return navigate('/login');
  }
  //Assignment 1
  if(path === `/dashboard`){
    OnDashBoardCall();
  }
  document.getElementById('title').innerText=routes[path].title;
  //end

  const template = document.getElementById(route.templateId);
  const view = template.content.cloneNode(true);
  const app = document.getElementById('app');
  app.innerHTML = '';
  app.appendChild(view);

}

//Assignment 1
function OnDashBoardCall(){
    console.log(`Dashboard is shown`)
}

function onLinkClick(event) {
  event.preventDefault();
  navigate(event.target.href);
}

function navigate(path) {
    window.history.pushState({}, path, path);
    updateRoute();
  }


  window.onpopstate = () => updateRoute();
  updateRoute();