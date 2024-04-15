within vavBoxModel;
model urn_ex_vav_502
  "model for VAV terminal unit"
  extends Buildings.Templates.ZoneEquipment.VAVCoolingOnly(
    redeclare Buildings.Templates.ZoneEquipment.Components.Controls.G36VAVBoxReheat ctl(
      have_occSen=true,
      have_winSen=true,
      have_CO2Sen=true) 
    );

end urn_ex_vav_502;