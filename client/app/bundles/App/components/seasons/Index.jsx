import React from 'react';

const Index = ({ seasons }) => {
  let headers = seasons.map((season) => {
    return <h1 key={season.id}>{season.year}</h1>;
  });
  return (
      <div>
        { headers }
      </div>
      );
}

export default Index;
