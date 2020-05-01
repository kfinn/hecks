import React from 'react';
import ReactDOM from 'react-dom';

function Hello({ name }: { name: string } = { name: "Kevin" }) {
  return <div>Hello {name}!</div>
}

document.addEventListener('DOMContentLoaded', () => {
  ReactDOM.render(
    <Hello name="React" />,
    document.body.appendChild(document.createElement('div')),
  )
})
