test("latest page contains a version", async () => {
  const $ = await fetchPage("/gateway/latest/install/linux/rhel/");
  await expect($(".codeblock")).not.toContainText("kong-enterprise-edition-.rpm");
});
