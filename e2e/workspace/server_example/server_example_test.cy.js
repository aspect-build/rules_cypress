describe("Server example test", () => {
  it("Finds world", () => {
    cy.visit("/");
    cy.get("#hello").contains("world");
  });
});
