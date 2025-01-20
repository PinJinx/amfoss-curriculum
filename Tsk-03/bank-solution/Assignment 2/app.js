

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



async function createAccount(account) {
    try {
      const response = await fetch('//localhost:5000/api/accounts', {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: account
      });
      return await response.json();
    } catch (error) {
      return { error: error.message || 'Unknown error' };
    }
  }

  async function register() {
    const registerForm = document.getElementById('registerForm');
    const formData = new FormData(registerForm);
    const jsonData = JSON.stringify(Object.fromEntries(formData));
    const result = await createAccount(jsonData);
  
    if (result.error) {
      return console.log('An error occurred:', result.error);
    }
  
    console.log('Account created!', result);
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