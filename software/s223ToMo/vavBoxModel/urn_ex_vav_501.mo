within vavBoxModel;
model urn_ex_vav_501
  "model for VAV terminal unit"
  extends Buildings.Templates.ZoneEquipment.VAVReheat(
    redeclare Buildings.Templates.ZoneEquipment.Components.Controls.G36VAVBoxReheat ctl(
      have_occSen=true,
      have_winSen=true,
      have_CO2Sen=false) ,
    redeclare Buildings.Templates.Components.Coils.WaterBasedHeating coiHea(typVal=Buildings.Templates.Components.Types.Valve.TwoWayModulating));

end urn_ex_vav_501;